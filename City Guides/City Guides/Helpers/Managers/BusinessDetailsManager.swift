//
//  BusinessDetailsTests.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 14/05/1442 AH.
//

import UIKit

class BusinessDetailsManager {
    
    func checkPhoneAvailablility(phone: String?) -> String {
        var result = ""
        if phone == "" {
            result = "phone number is not available"
        } else {
            if let p = phone {
                result = p
            }
        }
        return result
    }
    
    func businessRating(rating: Int?) -> [String] {
        var arr = [String]()
        if let num = rating {
            
            if num > 0 {
                for _ in 1...num {
                    arr.append(Star.fill.rawValue)
                }
                
                if num < 5 {
                    let unfilledStars = 5 - num
                    for _ in 1...unfilledStars {
                        arr.append(Star.empty.rawValue)
                    }
                }
            } else {
                for _ in 1...5 {
                    arr.append(Star.empty.rawValue)
                }
            }
        }
        return arr
    }
    
    func addStarsToStackView(rating: Double?, stackView: UIStackView) {
        if let rating = rating {
            let starsArray = businessRating(rating: Int(rating))
            for star in starsArray {
                stackView.addArrangedSubview(UIImageView(image: UIImage(systemName: star)))
            }
        }
    }
    
    func dateFormat(date: String?, from format1: DateFormat, to format2: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format1.rawValue
        let dateObj = dateFormatter.date(from: date ?? "")
        dateFormatter.dateFormat = format2.rawValue
        let finalDate = dateFormatter.string(from: dateObj ?? Date())
        
        return finalDate
    }
    
    func weatherImage(_ condition: String) -> UIImage {
        var image: UIImage?
        switch condition {
        case _ where (condition.contains("rain") == true):
            image = UIImage(systemName: WeatherImage.cloudRain.rawValue)
        case _ where (condition.contains("cloud") == true):
            image = UIImage(systemName: WeatherImage.cloud.rawValue)
        case _ where (condition.contains("Overcast") == true):
            image = UIImage(systemName: WeatherImage.cloudSun.rawValue)
        case _ where (condition.contains("clear") == true):
            image = UIImage(systemName: WeatherImage.sunMin.rawValue)
        case _ where (condition.contains("drizzle") == true):
            image = UIImage(systemName: WeatherImage.cloudDrizzle.rawValue)
        default:
            image = UIImage(systemName: "cloud") // re-check here
        }
        return image!
    }
}

// MARK: - Enums
extension BusinessDetailsManager {
    enum Star: String {
        case fill = "star.fill"
        case empty = "star"
    }
    
    enum WeatherImage: String {
        case cloudRain = "cloud.rain.fill"
        case cloud = "cloud.fill"
        case cloudSun = "cloud.sun.fill"
        case sunMin = "sun.min.fill"
        case cloudDrizzle = "cloud.drizzle.fill"
    }
    
    enum DateFormat: String {
        case midium = "yyyy-MM-dd" // 2020-12-28
        case dayNameMD = "EEEE, MMM d" // Saturday, Dec 28
        case wholeDate = "yyyy-MM-dd HH:mm" // 2020-12-28 18:00
        case time = "h a" // 1 AM ( 12 hours )
    }
}
