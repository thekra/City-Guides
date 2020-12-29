//
//  BusinessesManager.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 13/05/1442 AH.
//

import UIKit
import CoreLocation

class BusinessesManager {
    var request = YelpRequest()
    
    /**
     a function to call the fetch request 
     - parameter coordinates: takes the user location coordinates as an input
     - parameter completion: The callback called after retrieval
     - returns: void
     */
    func fetchBusinesses(coordinates: CLLocationCoordinate2D, completion: @escaping (_ busi: BusinessesResponse) -> ())   {
        request.fetchBusinesses(coor: coordinates) { (result) in
            switch result {
            case let .success(busi):
                print("Successfully found \(busi.businesses.count) businesses.")
                DispatchQueue.main.async {
                    completion(busi)
                }
            case let .failure(error):
                print("Error fetching business: \(error)")
            }
        }
    }
    
    func businessStatus(statusLabel:UILabel, _ isClosed: Bool) {
        switch isClosed {
        case false:
            statusLabel.text = "In Business"
            statusLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        case true:
            statusLabel.text = "Closed"
            statusLabel.textColor = #colorLiteral(red: 0.6325919628, green: 0.08559093624, blue: 0.2397931218, alpha: 1)
        }
    }
}
