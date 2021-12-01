//
//  Passport.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 07.06.2021.
//

import Foundation

/*
 "passport": {
   "number": "string",
   "issue_country": "string",
   "date_of_expire": 0
 }
 */

class Passport: Codable, Equatable {
    var number: String
    var country: String
    var dateExpStr: String
    
    //Extra
    var dateExp: Date? { return dateExpStr.toDate(dF5_yyyyMMddTHHmmssZ) }
    
    init(number: String, country: String, dateExpStr: String) {
        self.number = number
        self.country = country
        self.dateExpStr = dateExpStr
    }
    
    // Equatable
    static func ==(lhs: Passport, rhs: Passport) -> Bool {
        return (lhs.number == rhs.number) &&
               (lhs.country == rhs.country) &&
               (lhs.dateExpStr == rhs.dateExpStr)
    }
}

// MARK: - Codable
extension Passport {
    private enum CodingKeys: String, CodingKey {
        case number = "number"
        case country = "issue_country"
        case dateExpStr = "date_of_expiry"
    }
}
