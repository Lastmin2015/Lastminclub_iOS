//
//  User.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.03.2021.
//

import Foundation

/*
 "id": "60abf15c4c6b8f0001368d40",
 "email": "aazorin.rus@mail.ru",
 "first_name": "Александр",
 "last_name": "Зорин",
 "password": "52aeccac116c529b3c25b52270ad5b152b1c107f",
 "phone": "",
 "picture_file_name": "https://scontent.fhen2-1.fna.fbcdn.net/v/t1.30497-1/cp0/c15.0.50.50a/p50x50/84628273_176159830277856_972693363922829312_n.jpg?_nc_cat=1&ccb=1-3&_nc_sid=12b3be&_nc_ohc=a1FpfWt5x6AAX9ewRqa&_nc_ht=scontent.fhen2-1.fna&tp=27&oh=da3542cc77adf1d8c562dd874aeb83de&oe=60D166B8",
 "locale": "",
 "role": 0,
 "token_reset": "",
 "created_at": 1621881180,
 "updated_at": 1621881180
 ----
 {
   "email": "string",
   "first_name": "string",
   "middle_name": "string",
   "last_name": "string",
   "phone": "string",
   "picture_file_name": "string",
   "birthday": 0,
   "passport": {
     "number": "string",
     "issue_country": "string",
     "date_of_expire": 0
   }
 }
*/

class User: Codable {
    var id: String = ""//UUID().uuidString
    var name: String = ""
    var patronymic: String = ""
    var surname: String = ""
    var birthdateStr: String = ""
    var email: String = ""
    var phone: String = ""
    var pathPhoto: String = ""
    var passport: Passport?
//    var birthDateStr: String?
//    var gender: Gender?
//    var isPromoInt: Int?
    
    //Extra
    var fullname: String { return "\(name) \(surname)" }
    var isUserApp: Bool { return self.id == appService.user?.id }
    var birthdate: Date? { return birthdateStr.toDate(dF5_yyyyMMddTHHmmssZ) }
    var fullPathPhoto: String { return (pathPhoto.isEmpty ? "" : "https://apitest.fun:9595/api/v1/storage/\(pathPhoto)") }
//    var birthDate: Date? { return birthDateStr?.toDate(dateF3_yyyyMMdd) }
//    var balance: Int = 0
//    var isPromo: Bool { return (isPromoInt == 1) }
}

// MARK: - Codable
extension User {
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "first_name"
        case patronymic = "middle_name"
        case surname = "last_name"
        case birthdateStr = "birthday"
        case email = "email"
        case phone = "phone"
        case pathPhoto = "picture_file_name"
        case passport = "passport"
    }
}
/*
 "id": "60abf15c4c6b8f0001368d40",
 "first_name": "Александр",
 "last_name": "Зорин",
 "email": "aazorin.rus@mail.ru",
 "phone": "",
 "picture_file_name": "https://scontent.fhen2-1.f166B8"
*/

// MARK: - signOut
extension User {
    static func isAuth() -> Bool { return (appService.user != nil) }
    static func signOut() {
        appService.user = nil
        appService.userPhoto = nil
        appService.token_delete()
        LocallyData.removeAll()
        KingfisherHelper.clearCache()
    }
}

// MARK: - Demo
extension User {
    static func demo() -> User {
        let user = User()
        user.name = "Aleksandr"
        user.patronymic = "Aleksandrovich"
        user.surname = "Zorin"
        return user
    }
    static func demo2() -> User {
        let user = User()
        user.name = "Yulia"
        user.patronymic = "Aleksandrovna"
        user.surname = "Zorina"
        return user
    }
}
