//
//  AppService.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.03.2021.
//

import UIKit

let appService = AppService.shared

class AppService {
    // MARK: Constant
    static let shared = AppService()
    // MARK: Variables Data
    var isDebug: Bool = false
//    //++ShopData
    var countryList: [Country] = []
    var cityList: [City] = []
    var favHotelIdList: [String] = []
//    //++User
    var user: User?
    var userPhoto: UIImage? = nil
//    var addressList: [Address] = []
//    var searchList: [SearchData] = []
//    var lastAddress: YandexMapHelper.YAddress?
//    //++
    var tokenAccess: String = ""
    var tokenRefresh: String = ""
}

// MARK: - Token
extension AppService {
    func token_isExist() -> Bool {
        token_load()
        print(" 😻 token: \(tokenAccess)")
        return (!tokenAccess.isEmpty) && (!tokenRefresh.isEmpty)
    }
    func token_save(_ tokens: Tokens) {
        appService.tokenAccess = tokens.tokenAccess
        appService.tokenRefresh = tokens.tokenRefresh
        LocallyData.save_ktokenAccess(tokens.tokenAccess)
        LocallyData.save_ktokenRefresh(tokens.tokenRefresh)
    }
    func token_load() {
        if let tokenAccess = LocallyData.load_ktokenAccess(),
           let tokenRefresh = LocallyData.load_ktokenRefresh() {
            appService.tokenAccess = tokenAccess
            appService.tokenRefresh = tokenRefresh
        }
    }
    func token_delete() { token_save(Tokens("","")) }
}

// MARK: - setup_AppData
extension AppService {
    func setup_AppData_Shop(closure: @escaping (_ error: ErrorApp?) -> ()) {
        API.load_Data_Shop { (error) in closure(error) }
    }
    
    func load_AppData_Locally() {
        // Token
        token_load()
//        // Address
//        Address.loadLocally()
//        //appService.addressList = Address.demoList()
//        // Cart //Cart.clearLocally()
//        Cart.loadLocally()
//        print("Cart locally load: \(cart.list.count)")
//        // History Search List
//        SearchData.loadLocally()
    }
}
