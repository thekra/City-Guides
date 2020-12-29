//
//  YelpRequestsTests.swift
//  City GuidesTests
//
//  Created by Thekra Abuhaimed. on 14/05/1442 AH.
//

import XCTest
import CoreLocation
@testable import City_Guides

class YelpRequestsTests: XCTestCase {

    var request: YelpRequest!
    
    override func setUp() {
        super.setUp()
        request = YelpRequest()
    }
    
    override func tearDown() {
        request = nil
        super.tearDown()
    }
    
    func testCreatePhotoFromValidDictionary() {
        let result = request.processBusinessRequest(data: Constants.jsonData, error: nil)
        switch result {
        case let .success(business):
            XCTAssertNotNil(business)
            let business = business.businesses.first
            XCTAssertEqual(business?.id, (Constants.firstBusinessInfo["id"] as! String))
        case let .failure(error):
            XCTFail("Error fetching photos: \(error)")
        }
    }
    
    func testFetchBusinessesCompletionQueue() {
        request.fetchBusinesses(coor: CLLocationCoordinate2D(latitude: 40.759211, longitude: -73.984638)) { (result) -> Void in
            XCTAssertEqual(OperationQueue.current,
                           OperationQueue.main,
                           "Completion handler should run on the main thread; it did not.")
        }
    }
}

extension YelpRequestsTests {
    
    struct Constants {
        
        static let firstBusinessInfo: [String:Any] = {
                    let info: [String:Any] = [
                        "id": "WHRHK3S1mQc3PmhwsGRvbw",
                        "name": "Bibble & Sip"
                    ]
                    return info
                }()
        
        
        static let jsonData =
            ##"""
            {
                "businesses": [
                    {
                        "id": "WHRHK3S1mQc3PmhwsGRvbw",
                        "alias": "bibble-and-sip-new-york-2",
                        "name": "Bibble & Sip",
                        "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/gX847-f2s1X65RkzsFAWBA/o.jpg",
                        "is_closed": false,
                        "url": "https://www.yelp.com/biz/bibble-and-sip-new-york-2?adjust_creative=FofP_43dT_NKznNvZ5LG0g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=FofP_43dT_NKznNvZ5LG0g",
                        "review_count": 4863,
                        "categories": [
                            {
                                "alias": "coffee",
                                "title": "Coffee & Tea"
                            },
                            {
                                "alias": "bakeries",
                                "title": "Bakeries"
                            }
                        ],
                        "rating": 4.5,
                        "coordinates": {
                            "latitude": 40.76282,
                            "longitude": -73.98518
                        },
                        "location": {
                            "city": "New York",
                            "zip_code": "10019",
                            "country": "US",
                            "state": "NY",
                            "display_address": [
                                "253 W 51st St",
                                "New York, NY 10019"
                            ]
                        },
                        "phone": "+16466495116",
                        "display_phone": "(646) 649-5116",
                        "distance": 405.28315930149114
                    }
                ]
            }
    """##.data(using: .utf8)!
    }
}
