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
    
    private let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getUserDetails()
        
    }
    
    
    
  /**  func getUserDetails() {
        
        // Get the details of the current user logged on.
        let user = Auth.auth().currentUser
        if let user = user {
          
            let uid = user.uid
            let email = user.email
            
        }
        
    } **/
    
  
    @IBAction func uploadPhotoTapped(_ sender: Any) {
    
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
        
    }
    
    var globalPath = ""
    
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

    func addReportToDatabase(globalPath: String) {
        
        // Save a reference to the file in Firestore DB
        let db = Firestore.firestore()
        db.collection("images").document().setData(["url":self.globalPath])
        
    }
    
}
