//
//  WeatherRequestsTests.swift
//  City GuidesTests
//
//  Created by Thekra Abuhaimed. on 14/05/1442 AH.
//

import XCTest
import CoreLocation

@testable import City_Guides

class WeatherRequestsTests: XCTestCase {
    var request: WeatherRequest!
    
    override func setUp() {
        super.setUp()
        request = WeatherRequest()
    }
    
    override func tearDown() {
        request = nil
        super.tearDown()
    }
    
    func testCreateWeatherFromValidDictionary() {
        let result = request.processForcastRequest(data: Constants.jsonData, error: nil)
        switch result {
        case let .success(weather):
            XCTAssertNotNil(weather)
            let w = weather
            XCTAssertEqual(w.location?.name, "Long Island City")
        case let .failure(error):
            XCTFail("Error fetching photos: \(error)")
        }
    }
    
    func testFetchWeatherCompletionQueue() {
        request.fetchWeather(coordinates: CLLocationCoordinate2D(latitude: 40.759211, longitude: -73.984638)) { (result) -> Void in
            XCTAssertEqual(OperationQueue.current,
                           OperationQueue.main,
                           "Completion handler should run on the main thread; it did not.")
        }
    }
}

extension WeatherRequestsTests {
    
    struct Constants {
        
        static let jsonData =
            ##"""
    { "location": {
        "name": "Long Island City",
        "region": "New York",
        "country": "United States of America",
        "lat": 40.76,
        "lon": -73.98,
        "localtime_epoch": 1609220237,
        "localtime": "2020-12-29 0:37"
    },
    "current": {
        "last_updated_epoch": 1609218905,
        "last_updated": "2020-12-29 00:15",
        "temp_c": 6.1,
        "temp_f": 43.0
    },
    "forecast": {
        "forecastday": [
            {
                "date": "2020-12-29",
                "date_epoch": 1609200000,
                "day": {
                    "maxtemp_c": 2.4,
                    "maxtemp_f": 36.3,
                    "mintemp_c": -0.8,
                    "mintemp_f": 30.6,
                    "avgtemp_c": 1.1,
                    "avgtemp_f": 34.0,
                    "avgvis_miles": 6.0,
                    "avghumidity": 47.0,
                    "daily_will_it_rain": 0,
                    "daily_chance_of_rain": "0",
                    "daily_will_it_snow": 0,
                    "daily_chance_of_snow": "0",
                    "condition": {
                        "text": "Partly cloudy",
                        "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png",
                        "code": 1003
                    }
                },
                "hour": [
                    {
                        "time_epoch": 1609218000,
                        "time": "2020-12-29 00:00",
                        "temp_c": 4.3,
                        "temp_f": 39.7,
                        "is_day": 0,
                        "condition": {
                            "text": "Clear",
                            "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png",
                            "code": 1000
                        }
                    },
                    {
                        "time_epoch": 1609221600,
                        "time": "2020-12-29 01:00",
                        "temp_c": 3.6,
                        "temp_f": 38.5,
                        "is_day": 0,
                        "condition": {
                            "text": "Partly cloudy",
                            "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png",
                            "code": 1003
                        }
                    },
                    {
                        "time_epoch": 1609225200,
                        "time": "2020-12-29 02:00",
                        "temp_c": 3.0,
                        "temp_f": 37.4,
                        "is_day": 0,
                        "condition": {
                            "text": "Clear",
                            "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png",
                            "code": 1000
                        }
                    },
                    {
                        "time_epoch": 1609228800,
                        "time": "2020-12-29 03:00",
                        "temp_c": 2.4,
                        "temp_f": 36.3,
                        "is_day": 0,
                        "condition": {
                            "text": "Clear",
                            "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png",
                            "code": 1000
                        }
                    },
                    {
                        "time_epoch": 1609232400,
                        "time": "2020-12-29 04:00",
                        "temp_c": 1.8,
                        "temp_f": 35.2,
                        "is_day": 0,
                        "condition": {
                            "text": "Clear",
                            "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png",
                            "code": 1000
                        }
                    },
                    {
                        "time_epoch": 1609236000,
                        "time": "2020-12-29 05:00",
                        "temp_c": 1.2,
                        "temp_f": 34.2,
                        "is_day": 0,
                        "condition": {
                            "text": "Clear",
                            "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png",
                            "code": 1000
                        }
                    },
                    {
                        "time_epoch": 1609239600,
                        "time": "2020-12-29 06:00",
                        "temp_c": 1.0,
                        "temp_f": 33.8,
                        "is_day": 0,
                        "condition": {
                            "text": "Clear",
                            "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png",
                            "code": 1000
                        }
                    },
                    {
                        "time_epoch": 1609243200,
                        "time": "2020-12-29 07:00",
                        "temp_c": 0.7,
                        "temp_f": 33.3,
                        "is_day": 0,
                        "condition": {
                            "text": "Clear",
                            "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png",
                            "code": 1000
                        }
                    },
                    {
                        "time_epoch": 1609246800,
                        "time": "2020-12-29 08:00",
                        "temp_c": 0.5,
                        "temp_f": 32.9,
                        "is_day": 1,
                        "condition": {
                            "text": "Sunny",
                            "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png",
                            "code": 1000
                        }
                    },
                    {
                        "time_epoch": 1609250400,
                        "time": "2020-12-29 09:00",
                        "temp_c": 0.7,
                        "temp_f": 33.3,
                        "is_day": 1,
                        "condition": {
                            "text": "Partly cloudy",
                            "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png",
                            "code": 1003
                        }
                    },
                    {
                        "time_epoch": 1609254000,
                        "time": "2020-12-29 10:00",
                        "temp_c": 0.8,
                        "temp_f": 33.4,
                        "is_day": 1,
                        "condition": {
                            "text": "Sunny",
                            "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png",
                            "code": 1000
                        }
                    },
                    {
                        "time_epoch": 1609257600,
                        "time": "2020-12-29 11:00",
                        "temp_c": 1.0,
                        "temp_f": 33.8,
                        "is_day": 1,
                        "condition": {
                            "text": "Partly cloudy",
                            "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png",
                            "code": 1003
                        }
                    },
                    {
                        "time_epoch": 1609261200,
                        "time": "2020-12-29 12:00",
                        "temp_c": 1.5,
                        "temp_f": 34.7,
                        "is_day": 1,
                        "condition": {
                            "text": "Partly cloudy",
                            "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png",
                            "code": 1003
                        }
                    },
                    {
                        "time_epoch": 1609264800,
                        "time": "2020-12-29 13:00",
                        "temp_c": 1.9,
                        "temp_f": 35.4,
                        "is_day": 1,
                        "condition": {
                            "text": "Partly cloudy",
                            "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png",
                            "code": 1003
                        }
                    },
                    {
                        "time_epoch": 1609268400,
                        "time": "2020-12-29 14:00",
                        "temp_c": 2.4,
                        "temp_f": 36.3,
                        "is_day": 1,
                        "condition": {
                            "text": "Partly cloudy",
                            "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png",
                            "code": 1003
                        }
                    },
                    {
                        "time_epoch": 1609272000,
                        "time": "2020-12-29 15:00",
                        "temp_c": 2.2,
                        "temp_f": 36.0,
                        "is_day": 1,
                        "condition": {
                            "text": "Sunny",
                            "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png",
                            "code": 1000
                        }
                    },
                    {
                        "time_epoch": 1609275600,
                        "time": "2020-12-29 16:00",
                        "temp_c": 2.1,
                        "temp_f": 35.8,
                        "is_day": 1,
                        "condition": {
                            "text": "Partly cloudy",
                            "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png",
                            "code": 1003
                        }
                    },
                    {
                        "time_epoch": 1609279200,
                        "time": "2020-12-29 17:00",
                        "temp_c": 1.9,
                        "temp_f": 35.4,
                        "is_day": 0,
                        "condition": {
                            "text": "Clear",
                            "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png",
                            "code": 1000
                        }
                    },
                    {
                        "time_epoch": 1609282800,
                        "time": "2020-12-29 18:00",
                        "temp_c": 1.2,
                        "temp_f": 34.2,
                        "is_day": 0,
                        "condition": {
                            "text": "Clear",
                            "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png",
                            "code": 1000
                        }
                    },
                    {
                        "time_epoch": 1609286400,
                        "time": "2020-12-29 19:00",
                        "temp_c": 0.6,
                        "temp_f": 33.1,
                        "is_day": 0,
                        "condition": {
                            "text": "Clear",
                            "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png",
                            "code": 1000
                        }
                    },
                    {
                        "time_epoch": 1609290000,
                        "time": "2020-12-29 20:00",
                        "temp_c": -0.1,
                        "temp_f": 31.8,
                        "is_day": 0,
                        "condition": {
                            "text": "Clear",
                            "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png",
                            "code": 1000
                        }
                    },
                    {
                        "time_epoch": 1609293600,
                        "time": "2020-12-29 21:00",
                        "temp_c": -0.3,
                        "temp_f": 31.5,
                        "is_day": 0,
                        "condition": {
                            "text": "Partly cloudy",
                            "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png",
                            "code": 1003
                        }
                    },
                    {
                        "time_epoch": 1609297200,
                        "time": "2020-12-29 22:00",
                        "temp_c": -0.6,
                        "temp_f": 30.9,
                        "is_day": 0,
                        "condition": {
                            "text": "Clear",
                            "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png",
                            "code": 1000
                        }
                    },
                    {
                        "time_epoch": 1609300800,
                        "time": "2020-12-29 23:00",
                        "temp_c": -0.8,
                        "temp_f": 30.6,
                        "is_day": 0,
                        "condition": {
                            "text": "Partly cloudy",
                            "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png",
                            "code": 1003
                        }
                    }
                ]
            }
        ]
    } }
    """##.data(using: .utf8)!
    }
}
