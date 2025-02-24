//
//  RealmManager.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 10/05/1442 AH.
//

import Foundation
import RealmSwift

class RealmManager {
    class func setRealmConfiguration() {
        let config = Realm.Configuration(
            // encryptionKey: key,
            // Set the new schema version. This must be greater than the previously used
            // version (if you’ve never set a schema version before, the version is 0).
            schemaVersion: 2,
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                //        if (oldSchemaVersion < 1) {
                //          migration.deleteData(forType: “Person”)
                //        }
                //        if (oldSchemaVersion < 1) {
                //          migration.enumerateObjects(ofType: “Person”) { oldObject, newObject in
                //            let stringValue = oldObject?[“age”] as? String ?? “”
                //            newObject?[“age”] = Int(stringValue) ?? 0
                //          }
                //        }
            })
        Realm.Configuration.defaultConfiguration = config
    }
}

//MARK:- Private Functions
extension RealmManager {
    
    @discardableResult
    class func saveBusinesses(_ busi: BusinessRealm) -> Bool {
        guard let realm = try? Realm() else { return false }
        do {
            try realm.write {
                realm.create(BusinessRealm.self, value: busi, update:.modified)
            }
        } catch {
            return false
        }
        return true
    }
    
    class func getAllBusinesses() -> Results<BusinessRealm>? {
        guard let realm = try? Realm() else {
            return nil }
        let results = realm.objects(BusinessRealm.self)
        
        return results
    }
    
    @discardableResult
    class func saveWeather(_ weather: BusinessWeather) -> Bool {
        guard let realm = try? Realm() else { return false }
        do {
            try realm.write {
                realm.create(BusinessWeather.self, value: weather, update:.modified)
            }
        } catch {
            return false
        }
        return true
    }
    
    class func getWeather() -> Results<BusinessWeather>? {
        guard let realm = try? Realm() else {
            return nil }
        let results = realm.objects(BusinessWeather.self)
        
        return results
    }
//    
//    class func deletePerson(_ person: Person) -> Bool {
//        guard let realm = try? Realm() else { return false }
//        do {
//            try realm.write {
//                realm.delete(person)
//            }
//            return true
//        } catch {
//            return false
//        }
//    }
//    
    class func getWeatherBy(id: String) -> BusinessWeather? {
        guard let realm = try? Realm() else { return nil }
        let result = realm.objects(BusinessWeather.self).filter("businessID =  %@", id).first
        return result
    }
}
