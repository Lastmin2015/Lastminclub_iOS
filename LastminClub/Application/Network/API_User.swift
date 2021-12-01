//
//  API_User.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 11.05.2021.
//

import Foundation

// MARK: - User
extension API {
    static func user(onResult: @escaping (Result<User, ErrorApp>)->()) {
        //https://apitest.fun:9595/api/v1/profile
        //и хедер "Authotization: Bearer {ACCESS_TOKEN}"
        let method = MethodAPI()
        method.path = "profile"
        method.method = .get
        method.parameters = nil
        method.headers = MethodAPI.bearerHeader()
        method.printInfo()
        
        RouteAPI().request(method) { (route) in
            printJSONString(route.dict, "user")
            if let error = route.error { onResult(.failure(error)); return }
            switch route.statusCode {
            case 200, 201: ()
            default: onResult(.failure(ErrorApp.setup(route))); return
            }
            
            guard let json = route.dict["result"] as? [String: Any],
                  let item = parseDict<User>().getObject(json)
            else { onResult(.failure(.invalidJSON(method.path))); return }
            onResult(.success(item))
        }
    }
    static func userUpdate(_ dict: [String: Any], closure: @escaping (ErrorApp?)->()) {
        //https://apitest.fun:9595/api/v1/profile
        let method = MethodAPI()
        method.path = "profile"
        method.method = .post
        method.parameters = dict
        method.headers = MethodAPI.bearerHeader()
        method.printInfo()

        RouteAPI().request(method) { (route) in
            printJSONString(route.dict, "user")
            if let error = route.error { closure(error); return }
            switch route.statusCode {
            case 200, 201: closure(nil)
            default: closure(ErrorApp.setup(route))
            }
        }
    }
    static func userPws_update(_ dict: [String: Any], closure: @escaping (ErrorApp?)->()) {
        //https://apitest.fun:9595/api/v1/profile/change-password'
        let method = MethodAPI()
        method.path = "profile/change-password"
        method.method = .post
        method.parameters = dict
        method.headers = MethodAPI.bearerHeader()
        method.printInfo()
        
        RouteAPI().request(method) { (route) in
            printJSONString(route.dict, "userPws_update")
            if let error = route.error { closure(error); return }
            switch route.statusCode {
            case 200: closure(nil)
            case 403: closure(.errorApp("The old password is invalid or new password not valid"))
            default: closure(ErrorApp.setup(route))
            }
        }
    }
}

/*
 static func userUpdate(_ dict: [String: Any], closure: @escaping (APIError?)->()) {
     //https://airy-gamma-291710.ew.r.appspot.com/v1/apps/users
     let method = MethodAPI()
     method.path = "users"
     method.method = .patch
     method.parameters = dict
     method.headers = MethodAPI.bearerHeader()
     method.printInfo()
     
     RouteAPI().request(method) { (route) in
         printJSONString(route.dict, "userUpdate")
         if let error = route.error { closure(error); return }
         switch route.statusCode {
         case 200:
             if let accessToken = route.dict["accessToken"] as? String, let refreshToken = route.dict["refreshToken"] as? String {
                 appService.token_save(accessToken, refreshToken)
                 print("update access_token: \(accessToken)")
             }
             closure(nil)
         case 403: closure(.errorApp("Указанный код недействителен"))
         case 404: closure(.errorApp("Код для указанного адреса электронной почты не найден"))
         case 409: closure(.errorApp("Пользователь с указанным адресом электронной почты уже существует"))
         default:
             guard let textError = route.dict["error"] as? String
             else { closure(.invalidJSON); return }
             closure(.errorApp(textError))
         }
     }
 }
 */
