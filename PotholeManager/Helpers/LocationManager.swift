//
//  LocationManager.swift
//  PotholeManager
//
//  Created by Alexis Manolis on 11/07/2022.
//

import Foundation
import CoreLocation


// Conform to CLLocationManagerDelegate
class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // Creating singleton to provide globally accessible shared instance of the class.
    static let shared = LocationManager()
    
    
    let manager = CLLocationManager()
    
    
    // Global completion handler.
    var completion: ((CLLocation) -> Void)?
    
    // Get users location.
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        
        self.completion = completion
        // Request permission when in use.
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
        
    }
    
    
    // Reverse geocoding.
    public func getLocationDetails(with location: CLLocation, completion: @escaping ((String?) -> Void)) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
            
            guard let place = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            
            print(place)
            
            var name = ""
            
            if let locality = place.locality {
                name += locality
            }
            
            if let adminRegion = place.administrativeArea {
                name += ", \(adminRegion)"
            }
            
            completion(name)
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        
        // When we have a location we call completion handler.
        completion?(location)
        manager.stopUpdatingLocation()
        
    }
    
}
