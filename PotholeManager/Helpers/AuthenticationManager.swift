//
//  SignUpManager.swift
//  PotholeManager
//
//  Created by Alexis Manolis on 09/08/2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase

class AuthenticationManager {
    
    
    public func signUpUser(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Bool) -> ()) {
        
        // Creating user
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
            // Check if errors
            if err != nil {
                // Error present
                completion(false)
            }
            else {
                
                // If no errors then create user and add to database.
                let db = Firestore.firestore()
                
                // Add a new user to the database.
                db.collection("users").addDocument(data: ["firstname":firstName, "lastname":lastName, "uid":result!.user.uid]) { (error) in
                    
                    if error != nil {
                        completion(false)
                    }
                }
                completion(true)
            }
        }
    }
    
    
    func getUserDetails() -> (uid: String, email: String?) {
        
        // Get the details of the current user logged on.
        let user = Auth.auth().currentUser
        if let user = user {
          
            let uid = user.uid
            let email = user.email
            
            return (uid, email)
            
        }
        
        return ("","")
        
    }
}
