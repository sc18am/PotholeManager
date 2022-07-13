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
import CoreLocation

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {


    @IBOutlet weak var streetTextField: UITextField!
    
    
    @IBOutlet weak var cityTextField: UITextField!
    
    
    @IBOutlet weak var residentialDistrictTextField: UITextField!
    
    
    @IBOutlet weak var postcodeTextField: UITextField!
    
    
    @IBOutlet weak var widthTextField: UITextField!
    
    
    @IBOutlet weak var depthTextField: UITextField!
    
    
    @IBOutlet weak var enterDetailsTextField: UITextField!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    private let storage = Storage.storage().reference()
    
    var manager: CLLocationManager?
    
    struct Coordinates {
        
        var userLongitude = 0.0
        var userLatitude = 0.0
        var locationName = ""
        
    }
    
    // Create instance of struct
    var userCoordinates = Coordinates()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.alpha = 0
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
    
    
    @IBAction func getLocationTapped(_ sender: Any) {
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
        
        
    }
    
    
    // locationManager delegate function.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        
        print(location)
        //streetTextField.text = "\(location.coordinate.longitude)"
        //cityTextField.text = "\(location.coordinate.latitude)"
        
        getUserCoordinates(with: location)
        getLocationDetails(with: location)
         
    }
    
    
    // Get users coordinates
    func getUserCoordinates(with location: CLLocation) {
        
        userCoordinates.userLongitude = location.coordinate.longitude
        userCoordinates.userLatitude = location.coordinate.latitude
        
    }
    
    
    // Gets the users location when pressed button and sets the fields for the user.
    func getLocationDetails(with location: CLLocation) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
            
            guard let place = placemarks?.first, error == nil else {
                return

            }
            
            var street = ""
            
            if let adminArea = place.administrativeArea {
                self.residentialDistrictTextField.text = "\(adminArea)"
                print("AA: \(adminArea)")
            }

            if let locality = place.locality {
                self.cityTextField.text = "\(locality)"
                print("L: \(locality)")
            }

            if let subThouroughfare = place.subThoroughfare {
                street += "\(subThouroughfare) "
                print("ST: \(subThouroughfare)")
            }
            if let thoroughfare = place.thoroughfare {
                street += "\(thoroughfare)"
                self.streetTextField.text = "\(street)"
                self.userCoordinates.locationName = street
                print("T: \(thoroughfare)")
            }
            if let postCode = place.postalCode {
                self.postcodeTextField.text = "\(postCode)"
                print("PC: \(postCode)")
            }
            print(place)
        }
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

            
            // Storing the report to the reports database.
            db.collection("reports").addDocument(data: ["url": globalPath, "street": street, "city": city, "residentialdistrict": residentialDistrict, "postcode": postcode, "width": width, "depth": depth, "details": enterDetails, "uid": uid, "email": email]) { (error) in

                if error != nil {
                    
                    //Show error message.
                    self.showError("Error uploading the report to the database.")
                }
            }
            
            
            // Storing the coordinates and the street name to the locations database.
            db.collection("locations").addDocument(data: ["longitude" : userCoordinates.userLongitude, "latitude": userCoordinates.userLatitude, "street": userCoordinates.locationName]) { (error) in
                
                if error != nil {
                    
                    self.showError("Error uploading location information.")
                }
                
            }
            
            
            print("Succesful")
            
        }
    }
    
    
}
