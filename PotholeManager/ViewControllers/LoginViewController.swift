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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    func setUpElements() {
        
        errorLabel.alpha = 0
    }
    
    
    
    

    @IBAction func loginTapped(_ sender: Any) {
        
        // TODO: Check that the fields are filled in.
        
        // Cleaning the text fields.
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Sign in user.
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Error loggin user in.
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                
                let  reportViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.reportViewController) as? ReportViewController
                
                self.view.window?.rootViewController = reportViewController
                self.view.window?.makeKeyAndVisible()
                
            }
        }
    }
}
