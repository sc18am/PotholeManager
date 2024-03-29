//
//  PostsViewController.swift
//  PotholeManager
//
//  Created by Alexis Manolis on 20/07/2022.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import MapKit

class PostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var table: UITableView!
    
    var postsList = [Post]()
    
    let errorHandler = ErrorHandlers()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData {
            self.table.reloadData()
        }
        
        table.dataSource = self
        table.delegate = self
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(swipedBack))
        swipeBack.direction = .right
        self.view.addGestureRecognizer(swipeBack)

    }
    
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        let search = searchTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        getFilteredPosts(with: search) {
            self.table.reloadData()
        }
    }
    
    
    
    // Swipe back function
    @objc func swipedBack() {
        
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = postsList[indexPath.row]
        let postId = post.id
        
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomPostTableViewCell
        
        // Custom delegate.
        cell.configure(with: postId)
        cell.delegate = self

        // Download and display the image in the cell.
        downloadURL(for: post.imageURL) { url in
            self.downloadImage(imageView: cell.postImageView, url: url)
        }
        
        // Display additional cell labels.
        cell.streetLabel.text = post.street
        cell.cityLabel.text = post.city
        cell.residentialDistrictLabel.text = post.residentialDistrict
        cell.zipCodeLabel.text = post.zipCode
        cell.widthLabel.text = post.width
        cell.depthLabel.text = post.depth
        cell.detailsLabel.text = post.furtherDetails    

        getLikeTotal(with: postId) { likes in
            cell.likeLabel.text = String(likes)
        }
        
        // Checks if user has the report liked.
        checkLiked(with: postId) { liked in
            
            if liked {
                cell.likeButton.setTitle("Unlike", for: .normal)
            }
            else {
                cell.likeButton.setTitle("Like", for: .normal)
            }
        }
        
        return cell
    }
    
    
    // Sets cells to constant size in table.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func downloadURL(for path: String, completion: @escaping (URL) -> Void) {
        
        // Get reference to storage.
        let storage = Storage.storage().reference()
        
        // Specify path.
        let fileRef = storage.child(path)

        // If successfully uploaded get the download URL of the image uploaded.
        fileRef.downloadURL { (url, error) in
            
            guard let url = url, error == nil else {

                return
            }
            
            completion(url)
        }
    }
    
    
    func downloadImage(imageView: UIImageView, url: URL) {
      
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        })
        
        task.resume()
        
    }
    
    // Function to get all the data from all the posts in the database.
    func getData(completion: @escaping () -> ()) {
        
        // Get reference to database.
        let db = Firestore.firestore()
        
        
        // Read the documents at posts path.
        db.collection("reports").getDocuments { snapshot, error in
            
            // Check for error
            if error == nil {
                
                if let snapshot = snapshot {
                    
                    // Get all documents and create posts from reports.
                    self.postsList = snapshot.documents.map { doc in
                        
                        let post = Post(id: doc.documentID,
                                        street: doc["street"] as? String ?? "",
                                        city: doc["city"] as? String ?? "",
                                        residentialDistrict: doc["residentialdistrict"] as? String ?? "",
                                        zipCode: doc["postcode"] as? String ?? "",
                                        width: doc["width"] as? String ?? "0",
                                        depth: doc["depth"] as? String ?? "0",
                                        furtherDetails: doc["details"] as? String ?? "",
                                        imageURL: doc["url"] as? String ?? "")
                        
                        return post
                    }
                    completion()
                }
            }
            else {
                
                // Handle error.
                self.errorHandler.showAlert()
                completion()
            }
        }
    }
    
    
    // Get posts from firestore database based on the users search query.
    func getFilteredPosts(with district: String, completion: @escaping () -> ()) {
        
        // Get reference to database.
        let db = Firestore.firestore()
        
        
        // Read the documents at posts path.
        db.collection("reports").whereField("postcode", isEqualTo: district).getDocuments { snapshot, error in
            
            // Check for error
            if error == nil {
                
                if let snapshot = snapshot {
                    
                    // Get all documents and create posts from reports.
                    self.postsList = snapshot.documents.map { doc in
                        
                        let post = Post(id: doc.documentID,
                                        street: doc["street"] as? String ?? "",
                                        city: doc["city"] as? String ?? "",
                                        residentialDistrict: doc["residentialdistrict"] as? String ?? "",
                                        zipCode: doc["postcode"] as? String ?? "",
                                        width: doc["width"] as? String ?? "0",
                                        depth: doc["depth"] as? String ?? "0",
                                        furtherDetails: doc["details"] as? String ?? "",
                                        imageURL: doc["url"] as? String ?? "")

                        return post
                    }

                    completion()
                }
            }
            else {
                
                // Handle error.
                self.errorHandler.showAlert()
                completion()
            }
        }
    }
    
    // Like the specific post based on the post id.
    func likePost(with postid: String, with uid: String, completion: @escaping () -> ()) {
        
        // Get reference to database.
        let db = Firestore.firestore()
        
        
        // Read the documents at posts path and update the fields.
        db.collection("reports").document(postid).updateData([
            "likedby": FieldValue.arrayUnion([uid])
        ])
        
        completion()
        
    }
    
    
    func unlikePost(with postid: String, with uid: String, completion: @escaping () -> ()) {
        
        // Get reference to database.
        let db = Firestore.firestore()
        
        
        // Read the documents at posts path and update the fields.
        db.collection("reports").document(postid).updateData([
            "likedby": FieldValue.arrayRemove([uid])
        ])
        
        completion()
        
    }
    
    // Get the likes of a specific post.
    func getLikeTotal(with postid: String, completion: @escaping (Int) -> ()) {
        
        // Get reference to database.
        let db = Firestore.firestore()
        
        
        // Read the documents at posts path and update the fields.
        db.collection("reports").document(postid).getDocument { snapshot, error in
            
            if let snapshot = snapshot, snapshot.exists {
                
                let elements = snapshot["likedby"] as? [String] ?? [""]
                
                // Check if the likes are empty.
                if elements == [""] {
                    completion(0)
                }
                else {
                    let likes = elements.count
                    completion(likes)
                }
            }
            else {
                self.errorHandler.showAlert()
                completion(0)
            }
        }
        
    }
    
    // Checks if user has the post liked returns true if yes and no if they dont.
    func checkLiked(with postid: String, completion: @escaping (Bool) -> ()) {
        
        let uid = getUserId()
        
        // Get reference to database.
        let db = Firestore.firestore()
        
        
        // Read the documents at posts path and update the fields.
        db.collection("reports").document(postid).getDocument { snapshot, error in
            
            if let snapshot = snapshot, snapshot.exists {
                
                let elements = snapshot["likedby"] as? [String] ?? [""]
                
                // Check if the likes are empty.
                if elements.contains(uid) {
                    completion(true)
                }
                else {
                    completion(false)
                }
            }
            else {
                self.errorHandler.showAlert()
                completion(false)
            }
        }
    }
    
    
    
    // Gets the users id currently logged on.
    func getUserId() -> (String) {
        
        // Get the details of the current user logged on.
        let user = Auth.auth().currentUser
        if let user = user {
          
            let uid = user.uid
            
            return (uid)
            
        }
        
        return ("")
        
    }
}


extension PostsViewController: CustomPostTableViewCellDelegate {
    
    func likeButtonTapped(with postid: String) {
        
        let uid = getUserId()
        
        checkLiked(with: postid, completion: { liked in
            
            if liked {
                self.unlikePost(with: postid, with: uid) {
                    self.getLikeTotal(with: postid) { likes in
                        self.table.reloadData()
                    }
                }
            }
            else {
                self.likePost(with: postid, with: uid) {
                    self.getLikeTotal(with: postid) { likes in
                        // Set like button with likes
                        self.table.reloadData()
                    }
                }
            }
        })
    }
    
}
