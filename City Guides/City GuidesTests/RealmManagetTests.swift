//
//  RealmManagetTests.swift
//  City GuidesTests
//
//  Created by Thekra Abuhaimed. on 14/05/1442 AH.
//

import XCTest
import RealmSwift
@testable import City_Guides

class RealmManagetTests: XCTestCase {
    var realmMng: RealmManager!
    
    override func setUp() {
        super.setUp()
        realmMng = RealmManager()
        // Use an in-memory Realm identified by the name of the current test.
        // This ensures that each test can't accidentally access or modify the data
        // from other tests or the application itself, and because they're in-memory,
        // there's nothing that needs to be cleaned up.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    func test_GetAllPhotos() {
        let first = BusinessRealm()
        first.id = "1"
        _ = RealmManager.saveBusinesses(first)
        let second = BusinessRealm()
        second.id = "2"
        _ = RealmManager.saveBusinesses(second)
        let all = RealmManager.getAllBusinesses()

        XCTAssertEqual(all?.count, 2, "should get all photos in the database")
    }
    
    func testThatBusinessIsCreated() {
        let data = BusinessRealm()
        let bool = RealmManager.saveBusinesses(data)
        
        XCTAssertTrue(bool)
    }
}
