//
//  WeatherManager.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 13/05/1442 AH.
//

import Foundation
import CoreLocation

class WeatherManager {
    var request = WeatherRequest()
    
    /**
     a function to call the fetch request 
     - parameter coordinates: takes the user location coordinates as an input
     - parameter completion: The callback called after retrieval
     - returns: void
     */
    func fetchWeather(coordinates: CLLocationCoordinate2D, completion: @escaping (_ weather: WeatherResponseR) -> ())   {
            request.fetchWeather(coordinates: coordinates) { (result) in
                switch result {
                case let .success(w):
                    print("Successfully found \(w).")
                    completion(w)
                case let .failure(error):
                    print("Error fetching weather: \(error)")
                }
            }
    }
}
