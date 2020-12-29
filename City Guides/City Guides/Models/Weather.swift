//
//  Weather.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 05/05/1442 AH.
//

import Foundation
import RealmSwift

// MARK: - A class with the business id and its weather
@objcMembers class BusinessWeather: Object, Codable {
    dynamic var businessID: String = ""
    dynamic var weather: WeatherResponseR? = nil
    
    override class func primaryKey() -> String {
        return "businessID"
    }
}

@objcMembers class WeatherResponseR: Object, Codable {
    dynamic var location: wLocationR? = nil
    dynamic var current: wCurrentR? = nil
    dynamic var forecast: wForecastR? = nil
    
    required override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        location = try container.decode(wLocationR.self, forKey: .location)
        current = try container.decode(wCurrentR.self, forKey: .current)
        forecast = try container.decode(wForecastR.self, forKey: .forecast)
        super.init()
    }
}

@objcMembers class wLocationR: Object, Codable {
    dynamic var name: String = ""
    dynamic var region: String = ""
    dynamic var country: String = ""
    dynamic var lat: Double = 0.0
    dynamic var lon: Double = 0.0
    dynamic var localtimeEpoch: Int = 0
    dynamic var localtime: String = ""
    
    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
    
    required override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        region = try container.decode(String.self, forKey: .region)
        country = try container.decode(String.self, forKey: .country)
        lat = try container.decode(Double.self, forKey: .lat)
        lon = try container.decode(Double.self, forKey: .lon)
        localtimeEpoch = try container.decode(Int.self, forKey: .localtimeEpoch)
        localtime = try container.decode(String.self, forKey: .localtime)
        super.init()
    }
}

@objcMembers class wCurrentR: Object, Codable {
    dynamic var lastUpdatedEpoch: Int = 0
    dynamic var lastUpdated: String = ""
    dynamic var tempC: Double = 0.0
    dynamic var tempF: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case lastUpdatedEpoch = "last_updated_epoch"
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case tempF = "temp_f"
    }
    
    required override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        lastUpdatedEpoch = try container.decode(Int.self, forKey: .lastUpdatedEpoch)
        lastUpdated = try container.decode(String.self, forKey: .lastUpdated)
        tempC = try container.decode(Double.self, forKey: .tempC)
        tempF = try container.decode(Double.self, forKey: .tempF)
        super.init()
    }
}
@objcMembers class wForecastR: Object, Codable {
    let forecastday = List<wForecastdayR>()
    
    required override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let f = try container.decode([wForecastdayR].self, forKey: .forecastday)
        forecastday.append(objectsIn: f)
        super.init()
    }
}

@objcMembers class wForecastdayR: Object, Codable {
    dynamic var date: String = ""
    dynamic var dateEpoch: Int = 0
    dynamic var day: wDayR? = nil
    let hour = List<wHourR>()
    
    enum CodingKeys: String, CodingKey {
        case date
        case dateEpoch = "date_epoch"
        case day, hour
    }
    
    required override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        date = try container.decode(String.self, forKey: .date)
        dateEpoch = try container.decode(Int.self, forKey: .dateEpoch)
        day = try container.decode(wDayR.self, forKey: .day)
        let h = try container.decode([wHourR].self, forKey: .hour)
        hour.append(objectsIn: h)
        super.init()
    }
}

@objcMembers class wDayR: Object, Codable {
    dynamic var maxtempC:  Double = 0.0
    dynamic var maxtempF: Double = 0.0
    dynamic var mintempC: Double = 0.0
    dynamic var mintempF: Double = 0.0
    dynamic var avgtempC: Double = 0.0
    dynamic var avgtempF: Double = 0.0
    dynamic var avgvisMiles: Int = 0
    dynamic var avghumidity: Int = 0
    dynamic var dailyWillItRain: Int = 0
    dynamic var dailyChanceOfRain: String = ""
    dynamic var dailyWillItSnow: Int = 0
    dynamic var dailyChanceOfSnow: String = ""
    dynamic var condition: wConditionR? = nil
    
    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case maxtempF = "maxtemp_f"
        case mintempC = "mintemp_c"
        case mintempF = "mintemp_f"
        case avgtempC = "avgtemp_c"
        case avgtempF = "avgtemp_f"
        case avgvisMiles = "avgvis_miles"
        case avghumidity
        case dailyWillItRain = "daily_will_it_rain"
        case dailyChanceOfRain = "daily_chance_of_rain"
        case dailyWillItSnow = "daily_will_it_snow"
        case dailyChanceOfSnow = "daily_chance_of_snow"
        case condition
    }
    
    required override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        maxtempC = try container.decode(Double.self, forKey: .maxtempC)
        maxtempF = try container.decode(Double.self, forKey: .maxtempF)
        mintempC = try container.decode(Double.self, forKey: .mintempC)
        mintempF = try container.decode(Double.self, forKey: .mintempF)
        avgtempC = try container.decode(Double.self, forKey: .avgtempC)
        avgtempF = try container.decode(Double.self, forKey: .avgtempF)
        avgvisMiles = try container.decode(Int.self, forKey: .avgvisMiles)
        avghumidity = try container.decode(Int.self, forKey: .avghumidity)
        dailyWillItRain = try container.decode(Int.self, forKey: .dailyWillItRain)
        dailyChanceOfRain = try container.decode(String.self, forKey: .dailyChanceOfRain)
        dailyWillItSnow = try container.decode(Int.self, forKey: .dailyWillItSnow)
        dailyChanceOfSnow = try container.decode(String.self, forKey: .dailyChanceOfSnow)
        condition = try container.decode(wConditionR.self, forKey: .condition)
        
        super.init()
    }
}

@objcMembers class wHourR: Object, Codable {
    dynamic var timeEpoch: Int = 0
    dynamic var time: String = ""
    dynamic var tempC: Double = 0.0
    dynamic var tempF: Double = 0.0
    dynamic var isDay: Int = 0
    dynamic var condition: wConditionR? = nil
    
    enum CodingKeys: String, CodingKey {
        case timeEpoch = "time_epoch"
        case time
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case condition
    }
    
    required override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        timeEpoch = try container.decode(Int.self, forKey: .timeEpoch)
        time = try container.decode(String.self, forKey: .time)
        tempC = try container.decode(Double.self, forKey: .tempC)
        tempF = try container.decode(Double.self, forKey: .tempF)
        isDay = try container.decode(Int.self, forKey: .isDay)
        condition = try container.decode(wConditionR.self, forKey: .condition)
        
        super.init()
    }
}
@objcMembers class wConditionR: Object, Codable {
    dynamic var text: String = ""
    dynamic var icon: String = ""
    dynamic var code: Int = 0
    
    required override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        text = try container.decode(String.self, forKey: .text)
        icon = try container.decode(String.self, forKey: .icon)
        code = try container.decode(Int.self, forKey: .code)
        
        super.init()
    }
}
