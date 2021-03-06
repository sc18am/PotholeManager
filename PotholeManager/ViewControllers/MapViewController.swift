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
        //table.dataSource = self
    }

    
    // Called when the data is retrieved and is used to pin plot the locations.
    func loadedLocations(locations: [Location]) {

        for location in locations {
            //print(location)
            
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
    
    
    
    // Function to plot the pins on the map.
    func drawLocationOnMap(location: Location, count: Int) {
        print("drawing point: \(location.streetName)")
        
        let pin = MKPointAnnotation()
        
        // Set severity of pothole based on how many times it has been reported.
        var severity = ""
        
        if count < 3 {
            severity = "Moderate"
        }
        else if count >= 3 && count <= 10 {
            severity = "Bad"
        }
        else {
            severity = "Extreme"
        }
        
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
                        
                        //print(temp)
                        locationList.append(temp)
                        
                    } // end for
                } // end snapshot
                
                //print("finished loop!!!!")
                completion(locationList)
                
            }
            else {
                // Handle error.
                //print("error!!!!")
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
