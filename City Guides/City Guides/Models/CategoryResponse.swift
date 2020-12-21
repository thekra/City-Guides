//
//  CategoryResponse.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 06/05/1442 AH.
//

import Foundation

// MARK: - CategoryResponse
struct CategoryResponse: Codable {
    let category: pCategory
}

// MARK: - Category
struct pCategory: Codable {
    let alias, title: String
    let parentAliases: [String]

    enum CodingKeys: String, CodingKey {
        case alias, title
        case parentAliases = "parent_aliases"
    }
}
