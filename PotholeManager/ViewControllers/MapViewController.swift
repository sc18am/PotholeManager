//
//  MapViewController.swift
//  PotholeManager
//
//  Created by Alexis Manolis on 13/07/2022.
//

import UIKit
import MapKit
import Firebase
import simd

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        
        getData(completion: loadedLocations)
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(swipedBack))
        swipeBack.direction = .right
        self.view.addGestureRecognizer(swipeBack)
    }

    
    // Swipe back function
    @objc func swipedBack() {
        
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    
    // Called when the data is retrieved and is used to pin plot the locations.
    func loadedLocations(locations: [Location]) {

        for location in locations {
            print("Loaded Location: \(location)")
            
            let count = checkDuplicates(locations: locations, streetName: location.streetName)
            drawLocationOnMap(location: location, count: count)
            
        }
    }
    
    
    
    // Get the number of times a specific location has had a pothole reported.
    func checkDuplicates(locations: [Location], streetName: String) -> Int {
        
        var count = 0
        
        for location in locations {
            if location.streetName == streetName{
                count += 1
            }
        }
        
        return count
    }
    
    
    
    // Check severity.
    func checkSeverity(count: Int) -> String {
        
        if count < 3 {
            return("Moderate")
        }
        else if count >= 3 && count <= 10 {
            return("Bad")
        }
        else {
            return("Extreme")
        }
        
    }
    
    
    // Function to plot the pins on the map.
    func drawLocationOnMap(location: Location, count: Int) {
        print("drawing point: \(location.streetName)")
        
        let pin = MKPointAnnotation()
        
        let severity = checkSeverity(count: count)
        
        pin.title = location.streetName
        pin.subtitle = severity
        pin.coordinate = CLLocationCoordinate2D(latitude: location.latitude,
                                                        longitude: location.longitude)
        
        
        mapView.addAnnotation(pin)
        //print("POINT ADDED")
    }
    
    
    
    // Function to get data about locations from firestore database.
    func getData(completion: @escaping ([Location]) -> Void) {
      
        // Get reference to the database.
        let db = Firestore.firestore()
        
        var locationList = [Location]()
        
        // Read the documents of the specific database
        db.collection("locations").getDocuments { snapshot, error in
            
            // Check for errors
            if error == nil {
                // No errors
                
                // Make sure snapshot is not empty.
                if let snapshot = snapshot, !snapshot.isEmpty {
                    // Get all the documents and create Location instances.
                    for doc in snapshot.documents {
                        let temp = Location(id: doc.documentID,
                                 longitude: doc["longitude"] as? Double ?? 0.0,
                                 latitude: doc["latitude"] as? Double ?? 0.0,
                                 streetName: doc["street"] as? String ?? "")
                        
                        locationList.append(temp)
                    }
                }
                
                completion(locationList)
                
            }
            else {

                completion(locationList)
            }
        }
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom") as? MKMarkerAnnotationView
        
        if annotationView == nil {
            // Create view
            annotationView = MKMarkerAnnotationView(annotation: annotation,
                                              reuseIdentifier: "custom")
        }
        else {
            annotationView?.annotation = annotation
        }
        
        // Set custom annotation pins.
        switch annotation.subtitle {
        
        case "Moderate":
            annotationView?.markerTintColor = UIColor.yellow
        case "Bad":
            annotationView?.markerTintColor = UIColor.orange
        case "Extreme":
            annotationView?.markerTintColor = UIColor.red
        default:
            break
        }
        
        return annotationView
        
    }

    
}
