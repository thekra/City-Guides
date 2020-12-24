//
//  LocationManager.swift
//  Explore
//
//  Created by Thekra Abuhaimed. on 20/04/1442 AH.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    
    var locationManager: CLLocationManager!
    static var currentLocation = CLLocationCoordinate2D() {
        didSet {
            delegate?.passCoor(coor: currentLocation)
        }
    }
    
    static var delegate: UpdateCoor?
    static var shared = LocationManager()
    
    //MARK:- CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            LocationManager.currentLocation = location.coordinate
        }
    }
    
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error", error)
    }
    
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
       
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
}
