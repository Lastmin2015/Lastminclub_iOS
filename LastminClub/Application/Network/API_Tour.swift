//
//  API_Tour.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 08.11.2021.
//

import Foundation

// MARK: - Tour
extension API {
    static func tourList(_ dict: JSON, onResult: @escaping (Result<[Tour], ErrorApp>)->()) {
        // https://apitest.fun:9595/api/v1/tour-tickets/search?origin=Tenerife&destination=Izmir&start_date=1631075935&end_date=1636346335&adults=2&children=0&with_data=true&locale=ru
        
        let method = MethodAPI()
        method.path = "tour-tickets/search\(dict.queryString)"
        method.method = .get
        method.parameters = nil
        method.headers = MethodAPI.defaultHeader
        method.printInfo()
        
        RouteAPI().request(method) { (route) in
            //printJSONString(route.dict, "searchFlight")
            if let error = route.error { onResult(.failure(error)); return }
            switch route.statusCode {
            case 200:
                let dictList = route.dict["result"] as? [JSON] ?? []
                let list = Tour.loadList(dictList)
                onResult(.success(list))
            default: onResult(.failure(ErrorApp.setup(route))); return
            }
            
            //guard let dictList = route.dict["result"] as? [[String: Any]]
            //else { onResult(.success([])); return }
            
//            let dictList = route.dict["result"] as? [[String: Any]] ?? []
//            let list = Flight.loadList(dictList)
//            onResult(.success(list))
        }
    }
}
