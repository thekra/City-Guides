//
//  BusinessDetailsTests.swift
//  City GuidesTests
//
//  Created by Thekra Abuhaimed. on 14/05/1442 AH.
//

import XCTest
@testable import City_Guides
class BusinessDetailsTests: XCTestCase {
    
    func testPhoneWhenNotNil() {
        let phone = "0551538433"
        let result = BusinessDetailsManager().checkPhoneAvailablility(phone: phone)
        XCTAssertTrue(result == phone)
    }

    func testPhoneWhenNil() {
        let phone = ""
        let result = BusinessDetailsManager().checkPhoneAvailablility(phone: phone)
        XCTAssertTrue(result == "phone number is not available")
    }
    
    func testBusinessRating() {
        let expectedArray = ["star.fill", "star.fill", "star.fill", "star.fill", "star"]
        let result =  BusinessDetailsManager().businessRating(rating: 4)
        XCTAssertEqual(result, expectedArray)
    }
    
    func testDateFormat() {
        let date = "2020-12-28 01:00"
        let expectedDateFormat = "1 AM"
        
        let result = BusinessDetailsManager().dateFormat(date: date, from: .wholeDate, to: .time)
        XCTAssertEqual(result, expectedDateFormat)
    }
}
