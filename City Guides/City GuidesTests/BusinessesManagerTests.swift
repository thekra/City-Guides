//
//  BusinessesManagerTests.swift
//  City GuidesTests
//
//  Created by Thekra Abuhaimed. on 13/05/1442 AH.
//

import XCTest
@testable import City_Guides
class BusinessesManagerTests: XCTestCase {
    
    func testUILabel() {
        let testLable = UILabel()
        testLable.text = "In Business"
        let expectedResultColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        let expectedResultText = "In Business"
        BusinessesManager().businessStatus(statusLabel: testLable, false)
        XCTAssertTrue(testLable.textColor == expectedResultColor)
        XCTAssertTrue(testLable.text == expectedResultText)
    }
}

