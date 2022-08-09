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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    

    func setUpElements() {
        
        errorLabel.alpha = 0
    }
 
    
    // Check to see if password format is correct.
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    
    // Error message to be displayed whenever there is an error.
    func showError(_ message:String){
        
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    
    func transitionToHome(){
        
        let  homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    
    func getFormDetails() -> SignUpFields {
        
        let signUpFields = SignUpFields(firstName: firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                        lastName: lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                        email: emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                        password: passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
        
        return signUpFields
        
    }
    
    // Check fields and make sure data is correct. If correct nil returned, else return error string.
    func validateFields(signUpFields: SignUpFields) -> String? {
        
        // Check not empty
     /*   if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        */
        if signUpFields.firstName == "" ||
            signUpFields.lastName == "" ||
            signUpFields.email == "" ||
            signUpFields.password == "" {
            return "Please fill in all fields"
        }
        
        // Check the password is secure.
       // let passwordTest = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
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
            showError(error!)
        }
        else {
            
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let authenticationManager = AuthenticationManager()
            
            authenticationManager.signUpUser(email: email, password: password, firstName: firstName, lastName: lastName) { result in
                
                if result == true {
                    self.transitionToHome()
                }
                else {
                    self.showError("Error Creating The User")
                }
            }
            /*
            // Creating user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check if errors
                if err != nil {
                    // Error present
                    self.showError("Error creating user")
                }
                else {
                    
                    // If no errors then create user and add to database.
                    let db = Firestore.firestore()
                    
                    // Add a new user to the database.
                    db.collection("users").addDocument(data: ["firstname":firstName, "lastname":lastName, "uid":result!.user.uid]) { (error) in
                        
                        if error != nil {
                            self.showError("Failed to add user to database.")
                        }
                    }
                    
                    // Transition to home screen
                    self.transitionToHome()
                    
                }
            }
             */
        }
    }
    
}
