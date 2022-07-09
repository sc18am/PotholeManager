//
//  HomeViewController.swift
//  PotholeManager
//
//  Created by Alexis Manolis on 01/06/2022.
//

import UIKit
import Photos
import FirebaseAuth
import FirebaseStorage
import Firebase
import FirebaseFirestore

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var streetTextField: UITextField!
    
    
    @IBOutlet weak var cityTextField: UITextField!
    
    
    @IBOutlet weak var residentialDistrictTextField: UITextField!
    
    
    @IBOutlet weak var postcodeTextField: UITextField!
    
    
    @IBOutlet weak var widthTextField: UITextField!
    
    
    @IBOutlet weak var depthTextField: UITextField!
    
    
    @IBOutlet weak var enterDetailsTextField: UITextField!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    private let storage = Storage.storage().reference()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.alpha = 0
        getUserDetails()
        
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
    
  
    @IBAction func uploadPhotoTapped(_ sender: Any) {
    
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
        
    }
    
    @IBAction func submitReportButtonTapped(_ sender: Any) {
        
        addReportToDatabase(globalPath: globalPath)
        
    }
    
    
    var globalPath = ""
    
    
    // Error message to be displayed whenever there is an error.
    func showError(_ message:String){
        
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    
    // Called when user finishes picking a photo.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        
        // Uploading bytes of the image.
        guard let imageData = image.pngData() else {
            return
        }
        
        // Specify the file path and name
        globalPath = "images/\(UUID().uuidString).png"
        let fileRef = storage.child(globalPath)
        
        
        // Upload the data.
        fileRef.putData(imageData, metadata: nil) { (_, error) in
            
            guard error == nil else {
                print("Failed to upload")
                return
            }
            
            
            // Save a reference to the file in Firestore DB
            //let db = Firestore.firestore()
            //db.collection("images").document().setData(["url":self.globalPath])
            
            
            
            // If successfully uploaded get the download URL of the image uploaded.
            fileRef.downloadURL { (url, error) in
                
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                
                
                // ** WORKS BUT NEED TO FIX WITH BOUNDARIES ** //
                //DispatchQueue.main.async{
                //    self.label.text = urlString
                //    self.imageView.image = image
                //}
                
                print("Download URL: \(urlString)")
                UserDefaults.standard.set(url, forKey: "url") // To download the latest image - Not sure needed.
                
            }
            
        }

    }

    
    // Called when picker is cancelled.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }

    
    
    
    // Check fields and validate that data is correct. If correct then return nil else return error message.
    func validateFields() -> String? {
        
        // Check that necessary fields are filled in.
        if streetTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            cityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            residentialDistrictTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            postcodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all required fields."
            
        }
        
        return nil
    }
    
    
    func addReportToDatabase(globalPath: String) {
        
        
        // Checking the fields are correct.
        let error = validateFields()
        
        
        // If there is an error show the error message.
        if error != nil {
            
            errorLabel.text = error!
            errorLabel.alpha = 1
            
        }
        else {
            
            // Store the report in the database. Get all the data.
            let street = streetTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let city = cityTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let residentialDistrict = residentialDistrictTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let postcode = postcodeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let width = widthTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let depth = depthTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let enterDetails = enterDetailsTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let uid = getUserDetails().uid
            let email = getUserDetails().email!
           
            
            // Save a reference to the file in Firestore DB
            let db = Firestore.firestore()
            //db.collection("reports").document().setData(["url":self.globalPath])
            
            db.collection("reports").addDocument(data: ["url": globalPath, "street": street, "city": city, "residentialdistrict": residentialDistrict, "postcode": postcode, "width": width, "depth": depth, "details": enterDetails, "uid": uid, "email": email]) { (error) in

                if error != nil {
                    
                    //Show error message.
                    self.showError("Error uploading the report to the database.")
                }
            }
            
            print("Succesful")
            
        }
    }
    
    
}
