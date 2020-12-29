//
//  WeatherRequest.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 05/05/1442 AH.
//

import Foundation
import CoreLocation

class WeatherRequest {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    /**
     A function to make a request to fetch for businesses with the search url
     
     - parameter completion: The callback called after retrieval
     - returns: void
     */
    
    func fetchWeather(coordinates: CLLocationCoordinate2D, completion: @escaping (Result<WeatherResponseR, Error>) -> Void) {
        
        let url = WeatherAPI.weatherURL(coor: coordinates)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.processForcastRequest(data: data, error: error)
            print("result", result)
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
    }
    
    
    /**
     A function to return the decoded json
     
     - parameter data: takes Data as an input
     - parameter error: takes Error as an input
     - returns: a Result of success or failure
     */
    func processForcastRequest(data: Data?, error: Error?) -> Result<WeatherResponseR, Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return WeatherAPI.forecast(fromJSON: jsonData)
    }
}
