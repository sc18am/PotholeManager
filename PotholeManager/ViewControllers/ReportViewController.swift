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

class ReportViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {


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
    
    var getLocationButtonTapped = false
    
    let errorHandler = ErrorHandlers()
    
    // Create instance of struct
    var userCoordinates = Coordinates()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.alpha = 0
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(swipedBack))
        swipeBack.direction = .right
        self.view.addGestureRecognizer(swipeBack)
        
        //Looks for single or multiple taps.
        let tapGesture = UITapGestureRecognizer(target: self,
                                 action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    // Swipe back function
    @objc func swipedBack() {
        
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    
    
    // If the user fills in the location part it gets the coordinates from the information entered.
    func setAddressCoordinates(with address: String, completion: @escaping (Bool) -> ()) {
        
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { placemarks, error in
            
            //let placemark = placemarks?.first
            //print("placemark = \(placemark)")
            guard let place = placemarks?.first, error == nil else {
                
                completion(false)
                return
            }
            
            var street = ""
            
            if let lat = place.location?.coordinate.latitude {
                self.userCoordinates.userLatitude = lat
            }
            if let lon = place.location?.coordinate.longitude {
                self.userCoordinates.userLongitude = lon
            }
            if let subThouroughfare = place.subThoroughfare {
                street += "\(subThouroughfare) "
            }
            if let thoroughfare = place.thoroughfare {
                street += "\(thoroughfare)"
                self.userCoordinates.locationName = street

            }
            //print("COORDINATES IN THE LOOP \(self.userCoordinates)")
            completion(true)
        }
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
        
        getLocationButtonTapped = true
        
    }
    
    
    // locationManager delegate function.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        
        getUserCoordinates(with: location)
        getLocationDetails(with: location)
         
    }
    
    
    // Get users coordinates
    func getUserCoordinates(with location: CLLocation) {
        
        userCoordinates.userLongitude = location.coordinate.longitude
        userCoordinates.userLatitude = location.coordinate.latitude
        //print(userCoordinates)
        
    }
    
    
    // Gets the users location when getLocation button pressed and sets the fields for the user.
    func getLocationDetails(with location: CLLocation) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
            
            guard let place = placemarks?.first, error == nil else {
                return

            }
            
            var street = ""
            
            if let adminArea = place.administrativeArea {
                self.residentialDistrictTextField.text = "\(adminArea)"
                //print("AA: \(adminArea)")
            }

            if let locality = place.locality {
                self.cityTextField.text = "\(locality)"
                //print("L: \(locality)")
            }
            if let subThouroughfare = place.subThoroughfare {
                street += "\(subThouroughfare) "
                //print("ST: \(subThouroughfare)")
            }
            if let thoroughfare = place.thoroughfare {
                street += "\(thoroughfare)"
                self.streetTextField.text = "\(street)"
                self.userCoordinates.locationName = street
                //print("T: \(thoroughfare)")
            }
            if let postCode = place.postalCode {
                self.postcodeTextField.text = "\(postCode)"
                //print("PC: \(postCode)")
            }
            //print(self.userCoordinates)
        }
    }
    
    
    
    
    @IBAction func submitReportButtonTapped(_ sender: Any) {
        
        let report = getReportDetail()
        
        // Checking the fields are correct.
        let error = validateFields()
        
        
        // If there is an error show the error message.
        if error != nil {
            
            errorLabel.text = error!
            errorLabel.alpha = 1
            
        }
        else {
            addReportToDatabase(globalPath: globalPath, report: report) { result, reportid in
                if result == true {
                    print(result)
                    self.transitionToMap()
                    self.getLocationButtonTapped = false
                } else {
                    print("ERROR HAPPNED TRY AGAIN")
                    self.getLocationButtonTapped = false
                }
            }
        }
    }
    
    
    var globalPath = ""
    
    
    
    func getReportDetail() -> ReportDetails {
            
            let authManager = AuthenticationManager()
            
            let report = ReportDetails(street: streetTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                   city: cityTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                   residentialDistrict: residentialDistrictTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                   postcode: postcodeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                   width: widthTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                   depth: depthTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                   enterDetails: enterDetailsTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                       uid: authManager.getUserDetails().uid,
                                       email: authManager.getUserDetails().email!,
                                   address: "\(streetTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)), \(cityTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)), \(residentialDistrictTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)), \(postcodeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))"
        )
        return report
    }
    
    // Error message to be displayed whenever there is an error.
    //func showError(_ message:String){
        
    //    errorLabel.text = message
    //    errorLabel.alpha = 1
        
    //}
    
    
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
    
    
    func addReportToDatabase(globalPath: String, report: ReportDetails, completion: @escaping (Bool, String) -> ()) {
        
            
            let db = Firestore.firestore()

            let ref = db.collection("reports").document()
            let reportid = ref.documentID
            
            if getLocationButtonTapped == false {
                //print("In the if with \(getLocationButtonTapped)")
                setAddressCoordinates(with: report.address, completion: { result in
                    
                    if result == true {
                        // Save a reference to the file in Firestore DB
                        
                        ref.setData(["url": globalPath, "street": report.street, "city": report.city, "residentialdistrict": report.residentialDistrict, "postcode": report.postcode, "width": report.width, "depth": report.depth, "details": report.enterDetails, "uid": report.uid, "email": report.email])

                        //print("Users Coordinates are: \(self.userCoordinates)")
                        self.addLocationToDatabase(reportid: reportid, street: self.userCoordinates.locationName, latitude: self.userCoordinates.userLatitude, longitude: self.userCoordinates.userLongitude)
                        
                        completion(true, reportid)
                    }
                    else {
                        self.errorHandler.showAlert()
                        completion(false, "")
                    }
                })
            }
            else {
                //print("Users Coordinates are: \(userCoordinates)")
                
                ref.setData(["url": globalPath, "street": report.street, "city": report.city, "residentialdistrict": report.residentialDistrict, "postcode": report.postcode, "width": report.width, "depth": report.depth, "details": report.enterDetails, "uid": report.uid, "email": report.email])
                
                
                addLocationToDatabase(reportid: reportid, street: userCoordinates.locationName, latitude: userCoordinates.userLatitude, longitude: userCoordinates.userLongitude)
                
                completion(true, reportid)
            }
    }
    
    
    // Function to store the location to the database.
    func addLocationToDatabase(reportid: String, street: String, latitude: Double, longitude: Double) {
        
        // Save a reference to the file in Firestore DB
        let db = Firestore.firestore()
        
        // Storing the coordinates and the street name to the locations database.
        db.collection("locations").addDocument(data: ["reportid": reportid, "longitude" : longitude, "latitude": latitude, "street": street]) { (error) in
            
            if error != nil {
                
                self.errorHandler.showAlert()
                //self.showError("Error uploading location information.")
            }
        }
        print("success")
    }
    
    
    
    func transitionToMap() {
        
        let  mapViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mapViewController) as? MapViewController
        
        self.view.window?.rootViewController = mapViewController
        self.view.window?.makeKeyAndVisible()
        
    }
    
    
    func transitionToPosts() {
        
        let postsViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.postsViewController) as? PostsViewController
        
        self.view.window?.rootViewController = postsViewController
        self.view.window?.makeKeyAndVisible()
        
    }
    
}
