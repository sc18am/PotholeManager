//
//  PostsViewController.swift
//  PotholeManager
//
//  Created by Alexis Manolis on 20/07/2022.
//

import UIKit
import Firebase
import FirebaseStorage
import MapKit

class PostsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    var postsList = [Post]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getData(completion: returnedPosts)
        getData {
            print("success")
            self.table.reloadData()
        }
        
        table.dataSource = self
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = postsList[indexPath.row]
        
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomPostTableViewCell
        
        print("POST URL IS: \(post.imageURL)")
        downloadURL(for: post.imageURL) { url in
            print("THIS IS THE URL \(url)")
            self.downloadImage(imageView: cell.postImageView, url: url)
              
        }
        
        print("I AM HERE")
        
        cell.streetLabel.text = post.street
        cell.cityLabel.text = post.city
        cell.residentialDistrictLabel.text = post.residentialDistrict
        cell.zipCodeLabel.text = post.zipCode
        cell.widthLabel.text = post.width
        cell.depthLabel.text = post.depth
        cell.detailsLabel.text = post.furtherDetails    
        
        print("END")
        
        return cell
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
                        
                       // print("Post: \(post)")
                        
                        return post
                    }
                    
                    print("Array size: \(self.postsList.count)")
                    completion()
                }
                
                
            }
            else {
                
                // Handle error.
                completion()
            }
            
        }
        
    }
    /*
    func returnedPosts(posts: [Post]){
        
        print("The length of the posts: \(posts.count)")
        
    
    } */
    
    /*
    func getData(completion: @escaping ([Post]) -> Void) {
        
        // Get reference to database.
        let db = Firestore.firestore()
        
        var postsList = [Post]()
        
        // Read the documents at posts path.
        db.collection("reports").getDocuments { snapshot, error in
            
            // Check for error
            if error == nil {
                
                if let snapshot = snapshot {
                    
                    // Get all documents and create posts from reports.
                    postsList = snapshot.documents.map { doc in
                        
                        let post = Post(id: doc.documentID,
                                        street: doc["street"] as? String ?? "",
                                        city: doc["city"] as? String ?? "",
                                        residentialDistrict: doc["district"] as? String ?? "",
                                        zipCode: doc["postcode"] as? String ?? "",
                                        width: doc["width"] as? Int ?? 0,
                                        depth: doc["depth"] as? Int ?? 0,
                                        furtherDetails: doc["details"] as? String ?? "",
                                        imageURL: doc["url"] as? String ?? "")
                        
                       // print("Post: \(post)")
                        
                        return post
                    }
                    
                    print("Array size: \(postsList.count)")
                    completion(postsList)
                }
                
                
            }
            else {
                
                // Handle error.
                completion(postsList)
            }
            
        }
        
    } */

}
