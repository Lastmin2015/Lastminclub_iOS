//
//  API_Flight.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 22.06.2021.
//

import Foundation

// MARK: - User
extension API {
    static func searchFlight(_ pathFilter: String, onResult: @escaping (Result<[Flight], ErrorApp>)->()) {
        ///flights/search?fly_from=FRA&fly_to=PRG&date_from=09%2F12%2F2021&date_to=10%2F12%2F2021&limit=12

        let method = MethodAPI()
        method.path = "flights/search\(pathFilter)".encodeUrl
        method.method = .get
        method.parameters = nil
        method.headers = MethodAPI.defaultHeader
        method.printInfo()
        
        RouteAPI().request(method) { (route) in
            //printJSONString(route.dict, "searchFlight")
            if let error = route.error { onResult(.failure(error)); return }
            switch route.statusCode {
            case 200: ()
            default: onResult(.failure(ErrorApp.setup(route))); return
            }
            
            //guard let dictList = route.dict["result"] as? [[String: Any]]
            //else { onResult(.success([])); return }
            
            let dictList = route.dict["result"] as? [[String: Any]] ?? []
            let list = Flight.loadList(dictList)
            onResult(.success(list))
        }
    }
}
