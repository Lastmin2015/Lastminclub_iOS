//
//  API_Auth.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 29.04.2021.
//

import Foundation

// MARK: - Auth
extension API {
    static func isExistEmail(_ email: String, onResult: @escaping (Result<Bool, ErrorApp>)->()) {
        //http://95.183.11.125:9595/api/v1/auth/check-email?email=ee%40wqw.ru
        let method = MethodAPI()
        method.path = "auth/check-email?email=\(email)"
        method.method = .get
        method.parameters = nil
        method.headers = MethodAPI.defaultHeader
        method.printInfo()
        
        RouteAPI().request(method) { (route) in
            printJSONString(route.dict, "checkCodeEmail")
            if let error = route.error { onResult(.failure(error)); return }
            switch route.statusCode {
            case 200, 201:
                guard let isExist = route.dict["result"] as? Bool
                else { onResult(.failure(.invalidJSON(method.path))); return }
                onResult(.success(isExist))
            case 302: onResult(.success(true))
            case 404: onResult(.success(false))
            case 422:
                let textError = "Unprocessable body entity"
                onResult(.failure(.errorApp(textError))); return
            default: onResult(.failure(ErrorApp.setup(route))); return
            }
        }
    }
    
    static func reg_email(_ dict: [String: Any], onResult: @escaping (Result<Tokens, ErrorApp>)->()) {
        //http://95.183.11.125:9595/api/v1/auth/sign-up
        let method = MethodAPI()
        method.path = "auth/sign-up"
        method.method = .post
        method.parameters = dict
        method.headers = MethodAPI.defaultHeader
        method.printInfo()

        RouteAPI().request(method) { (route) in
            printJSONString(route.dict, "register")
            if let error = route.error { onResult(.failure(error)); return }
            switch route.statusCode {
            case 200, 201:
                guard let json = route.dict["result"] as? [String: Any],
                      let tokenAccess = json["access_token"] as? String,
                      let tokenRefresh = json["refresh_token"] as? String
                else { onResult(.failure(.invalidJSON(method.path))); return }
                let tokens = Tokens(tokenAccess, tokenRefresh)
                onResult(.success(tokens))
            case 403:
                let textError = "The email or specified password is invalid"
                onResult(.failure(.errorApp(textError))); return
            default: onResult(.failure(ErrorApp.setup(route))); return
            }
        }
    }
    static func auth_email(_ dict: [String: Any], onResult: @escaping (Result<Tokens, ErrorApp>)->()) {
        //http://95.183.11.125:9595/api/v1/auth/sign-in
        let method = MethodAPI()
        method.path = "auth/sign-in"
        method.method = .post
        method.parameters = dict
        method.headers = MethodAPI.defaultHeader
        method.printInfo()

        RouteAPI().request(method) { (route) in
            printJSONString(route.dict, "auth_email")
            if let error = route.error { onResult(.failure(error)); return }
            switch route.statusCode {
            case 200, 201:
                guard let json = route.dict["result"] as? [String: Any],
                      let tokenAccess = json["access_token"] as? String,
                      let tokenRefresh = json["refresh_token"] as? String
                else { onResult(.failure(.invalidJSON(method.path))); return }
                let tokens = Tokens(tokenAccess, tokenRefresh)
                onResult(.success(tokens))
            case 403:
                let textError = "Incorrect password"
                onResult(.failure(.errorApp(textError))); return
            case 404:
                let textError = "The user with the specified email is exists"
                onResult(.failure(.errorApp(textError))); return
            default: onResult(.failure(ErrorApp.setup(route))); return
            }
//            switch route.statusCode {
//            case 403:
//                let textError = "Указан неверный пароль"
//                onResult(.failure(.errorApp(textError))); return
//            case 404:
//                let textError = "Пользователь с указанным адресом электронной почты не найден"
//                onResult(.failure(.errorApp(textError))); return
//            default: ()
//            }
//
//            guard let accessToken = route.dict["accessToken"] as? String,
//                  let refreshToken = route.dict["refreshToken"] as? String
//            else { onResult(.failure(.invalidJSON)); return }
//            onResult(.success((accessToken, refreshToken)))
        }
    }
    // refreshToken
    static func refreshToken(closure: @escaping (_ error: ErrorApp?)->()) {
        //https://apitest.fun:9595/api/v1/auth/refresh?token=sdsd
        let method = MethodAPI()
        method.path = "auth/refresh?token=\(appService.tokenRefresh)"
        method.method = .post
        method.parameters = nil
        method.headers = MethodAPI.refreshHeader()
        method.isRefreshToken = true
        method.printInfo()

        RouteAPI().request(method) { (route) in
            printJSONString(route.dict, "refreshToken")
            if let error = route.error { closure(error); return }
            switch route.statusCode {
            case 200:
                guard let json = route.dict["result"] as? [String: Any],
                      let tokenAccess = json["access_token"] as? String,
                      let tokenRefresh = json["refresh_token"] as? String
                else { closure(.invalidJSON(method.path)); return }
                let tokens = Tokens(tokenAccess, tokenRefresh)
                appService.token_save(tokens)
                closure(nil)
            default: closure(.invalidAuth); return
            }
        }
    }
//    // deleteToken
//    static func deleteToken(closure: @escaping (_ error: APIError?)->()) {
//        //https://airy-gamma-291710.ew.r.appspot.com/v1/apps/users/tokens
//        let method = MethodAPI()
//        method.path = "users/tokens"
//        method.method = .delete
//        method.parameters = nil
//        method.headers = MethodAPI.bearerHeader()
//        method.printInfo()
//
//        RouteAPI().request(method) { (route) in
//            printJSONString(route.dict, "deleteToken")
//            if let error = route.error { closure(error); return }
//            switch route.statusCode {
//            case 200: closure(nil)
//            default: closure(.invalidAuth); return
//            }
//        }
//    }
//    //
//    static func sendCodeEmail(_ dict: [String: Any], _ isCheckExistEmail: Bool = false, closure: @escaping (APIError?)->()) {
//        //https://airy-gamma-291710.ew.r.appspot.com/v1/apps/users/codes
//        let method = MethodAPI()
//        let exPath = isCheckExistEmail ? "?email=true" : ""
//        method.path = "users/codes\(exPath)"
//        method.method = .post
//        method.parameters = dict
//        method.headers = MethodAPI.defaultHeader
//        method.printInfo()
//
//        RouteAPI().request(method) { (route) in
//            printJSONString(route.dict, "sendCodeEmail")
//            if let error = route.error { closure(error); return }
//            switch route.statusCode {
//            case 201: closure(nil)
//            case 404: closure(.errorApp("Пользователь с указанным адресом электронной почты не найден"))
//            case 429: closure(.errorApp("Достигнут максимальный лимит попыток"))
//                //closure(nil)//closure(.errorApp("Срок действия предыдущего кода не истек"))
//            default:
//                guard let textError = route.dict["error"] as? String
//                else { closure(.invalidJSON); return }
//                closure(.errorApp(textError))
//            }
//        }
//    }
//    //
//    static func checkCodeEmail(_ code: String, _ email: String, closure: @escaping (APIError?)->()) {
//        //{{url}}/v1/apps/users/codes?code={{code}}
//        let method = MethodAPI()
//        method.path = "users/codes?code=\(code)&email=\(email)"
//        method.method = .get
//        method.parameters = nil
//        method.headers = MethodAPI.defaultHeader
//        //method.printInfo()
//
//        RouteAPI().request(method) { (route) in
//            //printJSONString(route.dict, "checkCodeEmail")
//            if let error = route.error { closure(error); return }
//            switch route.statusCode {
//            case 200:
//                guard let isValid = route.dict["valid"] as? Bool
//                else { closure(.invalidJSON); return }
//                if isValid { closure(nil) }
//                else { closure(.errorApp("Указанный код не верный!")) }
//            default:
//                guard let textError = route.dict["error"] as? String
//                else { closure(.invalidJSON); return }
//                closure(.errorApp(textError))
//            }
//        }
//    }
    static func pswRecovery(_ email: String, closure: @escaping (ErrorApp?)->()) {
        //http://95.183.11.125:9595/api/v1/auth/recovery?email=sd%40mawe.ru
        let method = MethodAPI()
        method.path = "auth/recovery?email=\(email)".encodeUrl
        method.method = .get
        method.parameters = nil
        method.headers = MethodAPI.defaultHeader
        method.printInfo()

        RouteAPI().request(method) { (route) in
            printJSONString(route.dict, "pswRecovery")
            if let error = route.error { closure(error); return }
            switch route.statusCode {
            case 200: closure(nil)
            case 422: closure(.errorApp("The user with the specified email not found"))
            default: closure(ErrorApp.setup(route))
            }
        }
    }
}

// MARK: - Auth social
extension API {
    // auth_social
    static func auth_social(_ typeAuth: TypeAuth, _ token: String, _ email: String?, onResult: @escaping (Result<Tokens, ErrorApp>)->()) {
        // {{url}}/auth/auth_social?token=1212&social_type=google&email=google
        let pathAdd = (email == nil) ? "" : "&email=\(email!)"
        let method = MethodAPI()
        method.path = "auth/auth_social?social_type=\(typeAuth.id)&token=\(token)\(pathAdd)".encodeUrl
        method.method = .post
        method.parameters = [:]
        method.headers = MethodAPI.defaultHeader
            //["accept": "application/json"]
            //["Content-Type": "application/json", "Authorization": "\(token)"]//Bearer
        method.printInfo()
        
        RouteAPI().request(method) { (route) in
            printJSONString(route.dict, "auth_social:")
            if let error = route.error { onResult(.failure(error)); return }
            switch route.statusCode {
            case 200, 201: ()
            default: onResult(.failure(ErrorApp.setup(route))); return
            }
            
            guard let json = route.dict["result"] as? [String: Any],
                  let tokenAccess = json["access_token"] as? String,
                  let tokenRefresh = json["refresh_token"] as? String
            else { onResult(.failure(.invalidJSON(method.path))); return }
            let tokens = Tokens(tokenAccess, tokenRefresh)
            onResult(.success(tokens))
        }
    }
}
