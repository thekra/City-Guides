//
//  Business.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 03/05/1442 AH.
//

import Foundation
import RealmSwift

// MARK: - BusinessesResponse
@objcMembers class BusinessesResponse: Object, Codable {
    let businesses = List<BusinessRealm>()
    
    required override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let business = try container.decode([BusinessRealm].self, forKey: .businesses)
        businesses.append(objectsIn: business)
        super.init()
    }
}

@objcMembers class BusinessRealm: Object, Codable {
    dynamic var id: String = ""
    dynamic var alias: String = ""
    dynamic var name: String = ""
    dynamic var imageURL: String = ""
    dynamic var isClosed: Bool = false
    dynamic var url: String = ""
    dynamic var reviewCount: Int = 0
    let categories = List<CategoryR>()
    dynamic var rating: Double = 0.0
    dynamic var coordinates: CoordinatesR? = nil
    dynamic var location: LocationR? = nil
    dynamic var phone: String = ""
    dynamic var displayPhone: String = ""
    dynamic var distance: Double = 0.0
    
    override class func primaryKey() -> String {
        return "id"
    }
    
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
    
    required override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        alias = try container.decode(String.self, forKey: .alias)
        name = try container.decode(String.self, forKey: .name)
        imageURL = try container.decode(String.self, forKey: .imageURL)
        isClosed = try container.decode(Bool.self, forKey: .isClosed)
        url = try container.decode(String.self, forKey: .url)
        reviewCount = try container.decode(Int.self, forKey: .reviewCount)
        
        let categoriesList = try container.decode([CategoryR].self, forKey: .categories)
        categories.append(objectsIn: categoriesList)
        
        rating = try container.decode(Double.self, forKey: .rating)
        coordinates = try container.decode(CoordinatesR.self, forKey: .coordinates)
        location = try container.decode(LocationR.self, forKey: .location)
        phone = try container.decode(String.self, forKey: .phone)
        displayPhone = try container.decode(String.self, forKey: .displayPhone)
        distance = try container.decode(Double.self, forKey: .distance)
        super.init()
    }
}

@objcMembers class LocationR: Object, Codable {
    dynamic var city: String? = ""
    dynamic var zipCode: String = ""
    dynamic var country: String = ""
    dynamic var state: String = ""
    dynamic var displayAddress = List<String>()
    
    enum CodingKeys: String, CodingKey {
        case city
        case zipCode = "zip_code"
        case country, state
        case displayAddress = "display_address"
    }
    
    required override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        city = try container.decode(String.self, forKey: .city)
        zipCode = try container.decode(String.self, forKey: .zipCode)
        country = try container.decode(String.self, forKey: .country)
        state = try container.decode(String.self, forKey: .state)
        let displayA = try container.decode([String].self, forKey: .displayAddress)
        displayAddress.append(objectsIn: displayA)
        super.init()
    }
}

@objcMembers class CoordinatesR: Object, Codable {
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude
    }
    
    required override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        super.init()
    }
    
}

@objcMembers class CategoryR: Object, Codable {
    dynamic var alias: String = ""
    dynamic var title: String = ""
    
    
    enum CodingKeys: String, CodingKey {
        case alias, title
    }
    
    required override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        alias = try container.decode(String.self, forKey: .alias)
        title = try container.decode(String.self, forKey: .title)
        super.init()
    }
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
