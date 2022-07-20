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

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData(completion: loadedLocations)

    }

    
    // Called when the data is retrieved and is used to pin plot the locations.
    func loadedLocations(locations: [Location]) {

        for location in locations {
            drawLocationOnMap(location: location)
        }
    }
    
    
    // Function to plot the pins on the map.
    func drawLocationOnMap(location: Location) {
        print("drawing point: \(location.streetName)")
        
        let annotations = MKPointAnnotation()
        
        annotations.title = location.streetName
        annotations.coordinate = CLLocationCoordinate2D(latitude: location.latitude,
                                                        longitude: location.longitude)
        
        mapView.addAnnotation(annotations)
        
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
                        
                        print(temp)
                        locationList.append(temp)
                    } // end for
                } // end snapshot
                
                print("finished loop!!!!")
                completion(locationList)
                
            }
            else {
                // Handle error.
                print("error!!!!")
                completion(locationList)
            }
        }
    }
}
