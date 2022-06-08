//
//  HomeViewController.swift
//  PotholeManager
//
//  Created by Alexis Manolis on 01/06/2022.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserDetails()
        // Do any additional setup after loading the view.
    }
    
    
    
    func getUserDetails() {
        
        // Get the details of the current user logged on.
        let user = Auth.auth().currentUser
        if let user = user {
          
            let uid = user.uid
            let email = user.email
            
            welcomeLabel.text = "Welcome " + uid + " " + email!
        }
        
    }
    
    
    
    

}
