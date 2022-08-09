//
//  HomeViewController.swift
//  PotholeManager
//
//  Created by Alexis Manolis on 07/08/2022.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserName { name in
            self.welcomeLabel.text = "Welcome \(name)"
        }
        
    }
    

    @IBAction func makeReportButtonTapped(_ sender: Any) {
        
        let reportViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.reportViewController) as? ReportViewController
        
        self.view.window?.rootViewController = reportViewController
        self.view.window?.makeKeyAndVisible()
        
    }
    

    @IBAction func viewMapButtonTapped(_ sender: Any) {
        
        let mapViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mapViewController) as? MapViewController
        
        self.view.window?.rootViewController = mapViewController
        self.view.window?.makeKeyAndVisible()
        
    }
    
    
    @IBAction func reportsButtonTapped(_ sender: Any) {
        
        let postsViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.postsViewController) as? PostsViewController
        
        self.view.window?.rootViewController = postsViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    
    
    @IBAction func myReportsButtonTapped(_ sender: Any) {
    
        let myPostsViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.myPostsViewController) as? MyPostsViewController
        
        self.view.window?.rootViewController = myPostsViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    
    
    // Gets the current users first name.
    func getUserName(completion: @escaping (String) -> ()) {
        
        let authManager = AuthenticationManager()
        
        // Get the details of the current user logged on.
        let uid = authManager.getUserDetails().uid
        

        print("THE USER ID IS: \(uid)")
        // Get reference to database.
        let db = Firestore.firestore()
            
        // Read the documents at posts path.
        db.collection("users").whereField("uid", isEqualTo: uid).getDocuments { snapshot, error in
            
            // Check for error
            if error == nil {
                
                if let snapshot = snapshot {
                    for doc in snapshot.documents {
                        
                        let userName = doc["firstname"] as? String ?? ""
                        completion(userName)
                    }
                }
                
            }
            else {
                // Handle error.
                print("ERROR")
                completion("")
            }
            
        }
        
    }
}
