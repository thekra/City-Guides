//
//  YelpAPI.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 03/05/1442 AH.
//

import Foundation

enum EndPoint: String {
    case search = "businesses/search"
    case categories = "categories/"
}

struct YelpAPI {
    static var main = "https://api.yelp.com/v3/"
    static var apiKey = "gMTonZerL6BgNDbif7SakFPb1b4t3itgLEJUJ7DmrIgZtCWe7SqKhwrERobiyu28Y4AFnHhuFmniS_G4hfJJDLR5-e1XTzb9XI1wR93BmkwhjPzm4dUj-Syuz9PbX3Yx"
    
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
    private static func searchURL(parameters: [String:String]?) -> URL {

        var components = URLComponents(string: main + EndPoint.search.rawValue)!
        var queryItems = [URLQueryItem]()
        
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
    static func searchURL(parameter: [String:String]? = ["location": "NYC"]) -> URL {
        
        return searchURL(parameters: parameter)
    }
    
    /**
     A function to decodes instances of a data type from JSON objects
     
     - parameter data: takes data as an input
     - returns: a Result of success or failure
     */
    static func businesses(fromJSON data: Data) -> Result<BusinessesResponse, Error> {
        do {
            let decoder = JSONDecoder()
            
            let response = try decoder.decode(BusinessesResponse.self, from: data)
            
            return .success(response)
        } catch let error {
            return .failure(error)
        }
    }
    
    static func category(fromJSON data: Data) -> Result<CategoryResponse, Error> {
        do {
            let decoder = JSONDecoder()
            
            let response = try decoder.decode(CategoryResponse.self, from: data)

            return .success(response)
        } catch let error {
            return .failure(error)
        }
    }
}
