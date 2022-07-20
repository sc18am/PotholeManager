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

    
    
    func loadedLocations(locations: [Location]) {
        print("end 2: \(locations.count)")
        
        for location in locations {
            drawLocationOnMap(location: location)
        }
    }
    
    
    
    func drawLocationOnMap(location: Location) {
        print("drawing point: \(location.streetName)")
        
        print(location.streetName)
        print(location.longitude)
        print(location.latitude)
        
    }
    
    
    
    
    func getData(completion: @escaping ([Location]) -> Void) {
        // Get reference to the database.
        let db = Firestore.firestore()
        var locationList = [Location]()
        
        
        // Read the documents of the specific database
        db.collection("locations").getDocuments { snapshot, error in
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
