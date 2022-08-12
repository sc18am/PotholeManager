//
//  MyPostsViewController.swift
//  PotholeManager
//
//  Created by Alexis Manolis on 08/08/2022.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth


class MyPostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
   
    var postsList = [MyPost]()
    
    let errorHandler = ErrorHandlers()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let uid = getUserId()
        
        getUsersPosts(with: uid) {
            self.table.reloadData()
        }
        
        table.dataSource = self
        table.delegate = self
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(swipedBack))
        swipeBack.direction = .right
        self.view.addGestureRecognizer(swipeBack)
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
        
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomMyPostsTableViewCell
        
        // Custom delegate.
        cell.configure(with: postId)
        cell.delegate = self
        
        
        downloadURL(for: post.imageURL) { url in
            
            self.downloadImage(imageView: cell.postImageView, url: url)
              
        }
        
        
        cell.streetLabel.text = post.street
        cell.cityLabel.text = post.city
        
        return cell
    }
    
    
    // Sets cells to constant size in table.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    // Get user id
    func getUserId() -> (String) {
        
        // Get the details of the current user logged on.
        let user = Auth.auth().currentUser
        if let user = user {
          
            let uid = user.uid
            
            return (uid)
            
        }
        
        return ("")
        
    }
    
    
    // Get posts from firestore database based on the users search query.
    func getUsersPosts(with uid: String, completion: @escaping () -> ()) {
        
        // Get reference to database.
        let db = Firestore.firestore()
        
        
        // Read the documents at posts path.
        db.collection("reports").whereField("uid", isEqualTo: uid).getDocuments { snapshot, error in
            
            // Check for error
            if error == nil {
                
                if let snapshot = snapshot {
                    
                    // Get all documents and create posts from reports.
                    self.postsList = snapshot.documents.map { doc in
                        
                        let post = MyPost(id: doc.documentID,
                                        street: doc["street"] as? String ?? "",
                                        city: doc["city"] as? String ?? "",
                                        imageURL: doc["url"] as? String ?? "")
                        
                        //print("Post: \(post.id)")
                        
                        return post
                    }
                    
                    print("Array size: \(self.postsList.count)")
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
    
    
    func downloadURL(for path: String, completion: @escaping (URL) -> Void) {
        
        // Get referance to storage.
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
    
    
    // Deletes the post with specified post id.
    func deletePost(with postid: String, completion: @escaping () -> ()) {
        
        // Get reference to database.
        let db = Firestore.firestore()
        
        
        // Delete the document selected.
        db.collection("reports").document(postid).delete()
        
        // Delete the same documents corresponding locations entry.
        getDocumentId(with: postid) { docid in
            db.collection("locations").document(docid).delete()
        }
        
        completion()
    }
    
    
    // Gets the report documents id.
    func getDocumentId(with postid: String, completion: @escaping (String) -> ()) {
        
        let db = Firestore.firestore()
        
        // Read the documents at posts path.
        db.collection("locations").whereField("reportid", isEqualTo: postid).getDocuments { snapshot, error in
            
            // Check for error
            if error == nil {
                
                if let snapshot = snapshot {
                    for doc in snapshot.documents {
                        
                        completion(doc.documentID)
                    }
                }
                
            }
            else {
                // Handle error.
                self.errorHandler.showAlert()
                completion("")
            }
        
        }

    }
    
}


extension MyPostsViewController: CustomMyPostsTableViewCellDelegate {
    
    func deleteButtonTapped(with postid: String) {
        
        let uid = getUserId()
        
        deletePost(with: postid) {
            self.getUsersPosts(with: uid) {
                self.table.reloadData()
            }

        }
        
    }
    
}
