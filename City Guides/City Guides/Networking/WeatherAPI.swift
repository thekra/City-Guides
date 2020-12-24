//
//  WeatherAPI.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 05/05/1442 AH.
//

import Foundation
import CoreLocation

struct WeatherAPI {
    static var main = "https://api.weatherapi.com/v1/forecast.json"
    static var apiKey = "18d72bb657e24420bbe55855202012"
    
    /**
     a function to prepare the array of URLQueryItem
     
     - parameter params: a dictionary of string values
     - parameter queryItems: an array of URLQueryItem
     - returns: an array of URLQueryItem
     */
    static func setQueryItems(params: [String:String], queryItems: inout [URLQueryItem]) -> [URLQueryItem] {
        _ = params.map { (key, value) in
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        return queryItems
    }
    
    /**
     a function to prepare the url
     
     - parameter parameters: an optional parameter for if there are additional parameters
     - returns: a component url
     */
    private static func weatherURL(parameters: [String:String]?) -> URL {

        var components = URLComponents(string: main)!
        var queryItems = [URLQueryItem]()
        let baseParams = [
            "key": WeatherAPI.apiKey
        ]
        _ = setQueryItems(params: baseParams, queryItems: &queryItems)
        
        if let additionalParams = parameters {
            _ = setQueryItems(params: additionalParams, queryItems: &queryItems)
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
    
    
    /**
     A function for the final url with the base parameters and the additional parameters if there are any
     
     - parameter endPoint: an enum to specify which endpoint to use
     - parameter parameters: an optional parameter for if there are additional parameters
     - returns: a url to use for the request api
     */
    static func weatherURL(coor: CLLocationCoordinate2D) -> URL {
        
        return weatherURL(parameters: ["q": "\(String(coor.latitude)),\(String(coor.longitude))"])
    }
    
    /**
     A function to decodes instances of a data type from JSON objects
     
     - parameter data: takes data as an input
     - returns: a Result of success or failure
     */
    static func forecast(fromJSON data: Data) -> Result<WeatherResponse, Error> {
        do {
            let decoder = JSONDecoder()
            
            let response = try decoder.decode(WeatherResponse.self, from: data)

            return .success(response)
        } catch let error {
            return .failure(error)
        }
    }
}
