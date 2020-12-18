//
//  Business.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 03/05/1442 AH.
//

import Foundation

// MARK: - BusinessesResponse
struct BusinessesResponse: Codable {
    let businesses: [Business]
}

// MARK: - Business
struct Business: Codable {
    let id, alias, name: String
    let imageURL: String
    let isClosed: Bool
    let url: String
    let reviewCount: Int
    let categories: [Category]
    let rating: Double
    let coordinates: Coordinates
    let location: Location
    let phone, displayPhone: String
    let distance: Double

    enum CodingKeys: String, CodingKey {
        case id, alias, name
        case imageURL = "image_url"
        case isClosed = "is_closed"
        case url
        case reviewCount = "review_count"
        case categories, rating, coordinates, location, phone
        case displayPhone = "display_phone"
        case distance
    }
}

// MARK: - Category
struct Category: Codable {
    let alias, title: String
}

// MARK: - Center
struct Coordinates: Codable {
    let latitude, longitude: Double
}

// MARK: - Location
struct Location: Codable {
    let address1, address2, address3, city: String?
    let zipCode, country, state: String
    let displayAddress: [String]

    enum CodingKeys: String, CodingKey {
        case address1, address2, address3, city
        case zipCode = "zip_code"
        case country, state
        case displayAddress = "display_address"
    }
}

extension Business: Equatable {
    static func == (lhs: Business, rhs: Business) -> Bool {
        true
    }
    
    
}
