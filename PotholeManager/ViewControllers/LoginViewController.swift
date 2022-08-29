//
//  LoginViewController.swift
//  PotholeManager
//
//  Created by Alexis Manolis on 01/06/2022.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    let errorHandler = ErrorHandlers()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(swipedBack))
        swipeBack.direction = .right
        self.view.addGestureRecognizer(swipeBack)
    }
    
    
    func setUpElements() {
        
        errorLabel.alpha = 0
    }
    
    
    // Swipe back function
    @objc func swipedBack() {
        
        let startViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.startViewController) as? StartViewController
        
        self.view.window?.rootViewController = startViewController
        self.view.window?.makeKeyAndVisible()
    }
    

    @IBAction func loginTapped(_ sender: Any) {
        
        // Cleaning the text fields.
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Sign in user.
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Error loggin user in.
                self.errorHandler.showError(message: error!.localizedDescription, errorLabel: self.errorLabel)
            }
            else {
                
                let  homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
                
            }
        }
    }
}
