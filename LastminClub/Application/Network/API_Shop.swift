//
//  API_Shop.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 08.11.2021.
//

import Foundation

// MARK: - Directory
extension API {
    // countryList
    static func countryList(_ dict: JSON, onResult: @escaping (Result<[Country], ErrorApp>)->()) {
        // https://apitest.fun:9595/api/v1/countries?with_data=true&locale=en

        let method = MethodAPI()
        method.path = "countries\(dict.queryString)"
        method.method = .get
        method.parameters = nil
        method.headers = MethodAPI.defaultHeader
        //method.printInfo()
        
        RouteAPI().request(method) { (route) in
            //printJSONString(route.dict, "searchFlight")
            if let error = route.error { onResult(.failure(error)); return }
            switch route.statusCode {
            case 200:
                let dictList = route.dict["result"] as? [JSON] ?? []
                let list = Country.loadList(dictList)
                onResult(.success(list))
            default: onResult(.failure(ErrorApp.setup(route))); return
            }
        }
    }
    // cityList
    static func cityList(_ dict: JSON, onResult: @escaping (Result<[City], ErrorApp>)->()) {
        //   'https://apitest.fun:9595/api/v1/cities?with_data=true&locale=en' \

        let method = MethodAPI()
        method.path = "cities\(dict.queryString)"
        method.method = .get
        method.parameters = nil
        method.headers = MethodAPI.defaultHeader
        //method.printInfo()
        
        RouteAPI().request(method) { (route) in
            //printJSONString(route.dict, "searchFlight")
            if let error = route.error { onResult(.failure(error)); return }
            switch route.statusCode {
            case 200:
                let dictList = route.dict["result"] as? [JSON] ?? []
                let list = City.loadList(dictList)
                onResult(.success(list))
            default: onResult(.failure(ErrorApp.setup(route))); return
            }
        }
    }
}
