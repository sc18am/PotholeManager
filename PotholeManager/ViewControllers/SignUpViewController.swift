//
//  SignUpViewController.swift
//  PotholeManager
//
//  Created by Alexis Manolis on 01/06/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    let errorHandler = ErrorHandlers()

    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setUpElements()
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(swipedBack))
        swipeBack.direction = .right
        self.view.addGestureRecognizer(swipeBack)
    }
    
    
    // Sets error label to not be visible.
    func setUpElements() {
        
        errorLabel.alpha = 0
    }
 
    
    // Swipe back function
    @objc func swipedBack() {
        
        let startViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.startViewController) as? StartViewController
        
        self.view.window?.rootViewController = startViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    
    // Used to go to HomeViewController.
    func transitionToHome(){
        
        let  homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    
    
    // Check to see if password format is correct.
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
        
    
    // Gets the details from all the fields.
    func getFormDetails() -> SignUpFields {
        
        let signUpFields = SignUpFields(firstName: firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                        lastName: lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                        email: emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                        password: passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
        
        return signUpFields
        
    }
    
    // Check fields and make sure data is correct. If correct nil returned, else return error string.
    func validateFields(signUpFields: SignUpFields) -> String? {
        
        if signUpFields.firstName == "" ||
            signUpFields.lastName == "" ||
            signUpFields.email == "" ||
            signUpFields.password == "" {
            return "Please fill in all fields"
        }
        
        // Check if password is secure
        if isPasswordValid(signUpFields.password) == false {
            return "Password must have 8 characters, at least one special character and number."
        }
        
        return nil
    }
    
    
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validating fields
        let signUpFields = getFormDetails()
        let error = validateFields(signUpFields: signUpFields)
        
        if error != nil {
            
            // Show error message if error.
            errorHandler.showError(message: error!, errorLabel: errorLabel)
        }
        else {
            
            let firstName = signUpFields.firstName
            let lastName = signUpFields.lastName
            let email = signUpFields.email
            let password = signUpFields.password
            
            let authenticationManager = AuthenticationManager()
            
            authenticationManager.signUpUser(email: email, password: password, firstName: firstName, lastName: lastName) { result in
                
                if result == true {
                    self.transitionToHome()
                }
                else {
                    self.errorHandler.showAlert()
                }
            }
        }
    }
    
}
