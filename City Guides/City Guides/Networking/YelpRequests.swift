//
//  YelpRequests.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 03/05/1442 AH.
//

import Foundation

class YelpRequest {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    /**
     A function to make a request to fetch for businesses with the search url
     
     - parameter completion: The callback called after retrieval
     - returns: void
     */
    
    func fetchBusinesses(completion: @escaping (Result<[Business], Error>) -> Void) {
        
        let url = YelpAPI.searchURL()
        var request = URLRequest(url: url)
        request.setValue("Bearer \(YelpAPI.apiKey)", forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.processBusinessRequest(data: data, error: error)
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
    func processBusinessRequest(data: Data?, error: Error?) -> Result<[Business], Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return YelpAPI.businesses(fromJSON: jsonData)
    }
}
