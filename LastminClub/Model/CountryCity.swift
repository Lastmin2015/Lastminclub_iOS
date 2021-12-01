//
//  City.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 22.06.2021.
//

import Foundation

// MARK: - Country
class Country: Codable {
    var id: String
    var name: String
    
    // MARK: - Initializers
    init?(json: JSON) {
        guard
            let id = json["id"] as? String,
            let nameDict = json["country_name"] as? JSON,
            let name = nameDict["name"] as? String
        else { return nil }
        
        self.id = id
        self.name = name
    }
}

// MARK: - API
extension Country {
    static func loadList(_ dict: [JSON]) -> [Country] {
        return dict.compactMap { Country.init(json: $0) }
    }
}

// MARK: - City
class City: Codable {
    var id: String
    var name: String
    var country: Country? //QW-sonra
    
    // MARK: - Initializers
    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.country = nil
    }
    init?(json: JSON) {
        guard
            let id = json["id"] as? String,
            let nameDict = json["city_name"] as? JSON,
            let name = nameDict["name"] as? String,
            let countryDict = json["country"] as? JSON,
            let country = Country(json: countryDict)
        else { return nil }
        
        self.id = id
        self.name = name
        self.country = country
    }
}

// MARK: - API
extension City {
    static func loadList(_ dict: [JSON]) -> [City] {
        return dict.compactMap { City.init(json: $0) }
    }
}
