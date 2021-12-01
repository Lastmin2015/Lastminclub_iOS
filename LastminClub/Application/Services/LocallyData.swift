//
//  LocallyData.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.04.2021.
//

import Foundation

// MARK: - NEW

let ldService = LDService.shared

class LDService {
    // MARK: Enum
    private enum UDKey: String, CaseIterable {
        //case isWasFirst
        case language
        
        var key: String { return self.rawValue }
    }
    // MARK: Constant
    static let shared = LDService()
    private let userDefaults: UserDefaults
    
    // MARK: - Initializers
    private init() {
        self.userDefaults = UserDefaults.standard
    }
    deinit {}
    
    // All
    class func removeAll() {
        let userDefaults = UserDefaults.standard
        UDKey.allCases.forEach { userDefaults.removeObject(forKey: $0.key) }
        userDefaults.synchronize()
    }
}

// MARK: - User
extension LDService {
    // Language
    var language: Language {
        get {
            guard let id = userDefaults.string(forKey: UDKey.language.key),
                  let item = Language.getById(id)
            else { return Language.main }
            return item
        }
        set {
            userDefaults.set(newValue.id, forKey: UDKey.language.key)
            userDefaults.synchronize()
        }
    }
    var isExistLanguage: Bool {
        get { return userDefaults.string(forKey: UDKey.language.key) != nil }
    }
}






// MARK: - OLD

let userDefaults = UserDefaults.standard

class LocallyData {
    // MARK: Constants
    static let ktokenAccess = "tokenAccess"
    static let ktokenRefresh = "tokenRefresh"
    static let kfavHotelIdList = "favHotelIdList"
    static let klastDataSearchTour = "lastDataSearchTour"
    static let klastOptionsFlightSearch = "lastOptionsFlightSearch"
    
    // All
    class func removeAll() {
        userDefaults.removeObject(forKey: ktokenAccess)
        userDefaults.removeObject(forKey: ktokenRefresh)
        userDefaults.removeObject(forKey: kfavHotelIdList)
        userDefaults.removeObject(forKey: klastDataSearchTour)
        userDefaults.removeObject(forKey: klastOptionsFlightSearch)
        userDefaults.synchronize()
    }
}

// MARK: - Functions Token
extension LocallyData {
    // ktokenAccess
    class func save_ktokenAccess(_ value: String) {
        userDefaults.set(value, forKey: ktokenAccess)
        userDefaults.synchronize()
    }
    class func load_ktokenAccess() -> String? {
        return userDefaults.string(forKey: ktokenAccess)
    }
    // ktokenRefresh
    class func save_ktokenRefresh(_ value: String) {
        userDefaults.set(value, forKey: ktokenRefresh)
        userDefaults.synchronize()
    }
    class func load_ktokenRefresh() -> String? {
        return userDefaults.string(forKey: ktokenRefresh)
    }
}

// MARK: - favHotelIdList
extension LocallyData {
    // kfavHotelIdList
    class func save_favHotelIdList(_ list: [String]) {
        userDefaults.set(list, forKey: kfavHotelIdList)
        userDefaults.synchronize()
    }
    class func load_favHotelIdList() -> [String] {
        let list: [String] = userDefaults.object(forKey: kfavHotelIdList) as? [String] ?? []
        return list
    }
    class func delete_favHotelIdList() { userDefaults.removeObject(forKey: kfavHotelIdList) }
}

// MARK: - Last data
extension LocallyData {
    //klastDataSearchTour
    class func save_klastDataSearchTour(_ item: DataSearchTour) {
        guard let dict = item.values else { return }
        userDefaults.set(dict, forKey: klastDataSearchTour)
        userDefaults.synchronize()
    }
    class func load_klastDataSearchTour() -> DataSearchTour? {
        guard let dict: [String: Any] = userDefaults.object(forKey: klastDataSearchTour) as? [String: Any],
              let item = parseDict<DataSearchTour>().getObject(dict)
        else { return nil }
        return item
    }
    //klastOptionsFlightSearch
    class func save_klastOptionsFlightSearch(_ item: OptionsFlightSearch) {
        guard let dict = item.values else { return }
        userDefaults.set(dict, forKey: klastOptionsFlightSearch)
        userDefaults.synchronize()
    }
    class func load_klastOptionsFlightSearch() -> OptionsFlightSearch? {
        guard let dict: [String: Any] = userDefaults.object(forKey: klastOptionsFlightSearch) as? [String: Any],
              let item = parseDict<OptionsFlightSearch>().getObject(dict)
        else { return nil }
        return item
    }
}
