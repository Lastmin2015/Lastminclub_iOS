//
//  RouteAPI.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 29.04.2021.
//

import Foundation
import Alamofire

class MethodAPI {
    //let basePath: String = "https://95.183.11.125:9595/api/v1/"
    let basePath: String = "https://apitest.fun:9595/api/v1/"

    var method: HTTPMethod = .get
    var path: String = ""
    var parameters: Any?
    var headers: HTTPHeaders = [:]
    var isRefreshToken: Bool = false
    
    // Extra
    var fullPath: String { return (path.contains("http") ? path : (basePath + path)).encodeUrl }
    var params: Parameters? {
        if let para  = parameters as? [String: Any] { return para }
        //else if let para = parameters as? [[String: Any]] { return para.asParameters() }
        //else if let para  = parameters as? String { return [para].asParameters() }
        else { return nil }
    }
    var description: String {
        return (path.components(separatedBy: "?").first ?? "") + " \(method.rawValue)"
    }
    
    // Helpers
    func printInfo() {
        print("infoMethodAPI: \n \(fullPath)", "\n parameters: \(parameters ?? [:])", "\n headers: \(headers)", "\n method: \(method.rawValue)")
    }
    
//    // Helpers
//    func printInfo() {
//        print("infoMethodAPI: \n \(fullPath())", "\n parameters: \(parameters ?? [:])", "\n headers: \(headers)", "\n method: \(method.rawValue)")
//    }
//    func fullPath() -> String {
//        if path.contains("http") { return path }
//        else { return basePath + path }
//    }
//    // request
//    func params() -> Parameters? {
//        if let para  = parameters as? [String: Any] { return para }
//        //else if let para = parameters as? [[String: Any]] { return para.asParameters() }
//        //else if let para  = parameters as? String { return [para].asParameters() }
//        else { return nil }
//    }
    
    // MARK: - Constants
    static let defaultHeader: HTTPHeaders = ["Content-Type": "application/json",
                                             "Accept": "application/json"]
    static func bearerHeader() -> HTTPHeaders {
        return ["Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer \(appService.tokenAccess)"]
    }
    static func refreshHeader() -> HTTPHeaders {
        return ["Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer \(appService.tokenRefresh)"]
    }
}
class API {  }

struct NetworkState {
    static var isConnected: Bool { return NetworkReachabilityManager()!.isReachable }
}

class RouteAPI {
    var method: MethodAPI?
    var statusCode: Int = 0
    var error: ErrorApp?
    var responseObject: Any?
    var dict: [String: Any] = [:]
    var dictList: [[String: Any]] = [[:]]
    
    func request(_ method: MethodAPI, closure: @escaping (RouteAPI)->()) {
        self.method = method
        guard NetworkState.isConnected
        else { self.error = ErrorApp.noInternet; closure(self); return }
        
        makeRequestJSON(method) { (routeAPI) in closure(routeAPI) }
    }
    
    func makeRequestJSON(_ method: MethodAPI, closure: @escaping (RouteAPI)->()) {
        //method.printInfo()
        
        AF.request(method.fullPath, method: method.method, parameters: method.params, encoding: JSONEncoding.prettyPrinted, headers: method.headers).responseJSON { (response) in
            
            self.statusCode = response.response?.statusCode ?? 0
            print("statusCode: \(self.statusCode) <-\(method.path.components(separatedBy: "?").first ?? "")")
            
            switch response.result {
            case .success(let responseObject):
                self.defineResponse(responseObject)
                //closure(self)
                guard (self.error == .refreshToken) else { closure(self); return }

                if method.isRefreshToken { self.error = .invalidAuth; closure(self); return }
                API.refreshToken { (error) in
                    if let error = error {
                        print("not update by refresh token: \(error.text)")
                        self.error = .invalidAuth; closure(self); return
                    }
                    self.error = nil
                    method.headers = ["Content-Type": "application/json",
                                      "Authorization": "Bearer \(appService.tokenAccess)"]
                    self.request(method) { (route) in closure(route) }
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.error = ErrorApp.custom(error.localizedDescription)
                closure(self)
            }
        }
    }
}

// MARK: - HelpersFunctions
extension RouteAPI {
    private func defineResponse(_ responseObject: Any?) {
        guard let value = responseObject else { return }
        self.responseObject = responseObject
        // detect json
        if let dict = value as? [String: Any] { self.dict = dict }
        else if let dictList = value as? [[String: Any]] { self.dictList = dictList }
        // detect error
        detectError()
    }
    private func detectError() {
        if self.statusCode == 401 { self.error = .refreshToken; return }
        //        // statusCode
        //        switch self.statusCode {
        //        case 409: self.error = .errorApp("Пользователь с указанным адресом электронной почты или телефонным номером уже существует")
        //        default: ()
        //        }
        //print(self.statusCode)
        //        if let errorValue = dict["error"] as? Int, errorValue != 0 {
        //            self.error = APIError.repeatLater
        //        }
//        if let errorDict = dict["error"] as? [String: Any] {
//            let textError = errorDict["message"] as? String ?? ""
//            let codeStr = "\(self.statusCode)"
//            self.error = .errorApp("Error (\(codeStr)): \(textError)")
//        }
    }
}
//* **500 Internal Server Error** - something went wrong on the server
//* **405 Method Not Allowed** - the request method for the specified endpoint is not allowed
//* **404 Not Found** - the endpoint does not exist
//* **401 Unauthorized** - the token not specified or invalid
//* **400 Bad Request** - the request has been formed incorrectly



// MARK: - uploadPhoto
extension RouteAPI {
    static func userPhoto_upload(_ image: UIImage, progressHandler: @escaping (Double) -> Void, onResult: @escaping (Result<String, ErrorApp>)->()) {
        //  'https://apitest.fun:9595/api/v1/profile/upload-avatar'
        //if !reachabilityManager.isConnection { completion(APIError.noInternet); return }
        
        let method = MethodAPI()
        method.path = "profile/upload-avatar"
        method.method = .post
        method.parameters = nil
        method.headers = MethodAPI.bearerHeader()
        method.printInfo()
        
        guard let imageData = image.toJPEGData(1),
              let urlRequest = try? URLRequest(url: method.fullPath, method: method.method, headers: method.headers) else {
            onResult(.failure(ErrorApp.custom("no imageData"))); return }
        
        AF.upload(multipartFormData: { multiPart in
            multiPart.append(imageData, withName: "file", fileName: "file", mimeType: "image/jpeg")
        }, with: urlRequest)
        .uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
            progressHandler(progress.fractionCompleted)
        }
        .responseJSON { response in
            let statusCode = response.response?.statusCode ?? 0
            switch response.result {
            case .success(let responseObject):
                switch statusCode {
                case 200: onResult(.success(""))
                case 401:
                    API.refreshToken { (error) in
                        if let error = error {
                            print("not update by refresh token: \(error.text)")
                            onResult(.failure(.invalidAuth))
                            return
                        }
                        RouteAPI.userPhoto_upload(image) { (progress) in
                            progressHandler(progress)
                        } onResult: { (result) in onResult(result) }

                        //method.headers = ["Content-Type": "application/json",
                        //                  "Authorization": "Bearer \(appService.tokenAccess)"]
                        //self.request(method) { (route) in closure(route) }
                    }
                default: onResult(.failure(.custom("error upload with code \(statusCode)")))
                }
                printJSONString(responseObject, "uploadPhoto")
            case .failure(let error):
                print("Upload error statusCode: \(statusCode)")
                onResult(.failure(.custom(error.localizedDescription)))
            }
        }
    }
}


//    private func doRefreshToken(_ method: Method) {
//        if method.isRefreshToken {
//            self.error = .invalidAuth
//            closure(self)
//            return
//        }
//        API.refreshToken { (error) in
//            if let error = error {
//                print("not update by refresh token: \(error.text)")
//                self.error = .invalidAuth
//                closure(self); return
//            }
//            self.error = nil
//            method.headers = ["Content-Type": "application/json",
//                              "Authorization": "Bearer \(appService.tokenAccess)"]
//            self.request(method) { (route) in closure(route) }
//        }
//    }

//                if self.statusCode == 401 {
//                    self.error = .refreshToken
//                    print(" ------!!!--------  refresh token...")
//                    API.refreshToken { (error) in
//                        if let error = error {
//                            print("Error refreshToken: \(error.text)")
//                            self.error = error
//                            closure(self)
//                        }
//                        else {
//                            self.error = nil
//                            //method.headers = MethodAPI.bearerHeader
//                            method.headers = ["Content-Type": "application/json",
//                                              "Authorization": "Bearer \(appService.tokenAccess)"]
//                            self.request(method) { (route) in closure(route) }
//                        }
//                    }
//                } else {
//                    self.defineResponse(responseObject)
//                    closure(self)
//                }

//// MARK: - uploadPhoto
//extension RouteAPI {
//    static func userPhoto_upload(_ image: UIImage, progressHandler: @escaping (Double) -> Void, onResult: @escaping (Result<String, APIError>)->()) {
//        //https://airy-gamma-291710.ew.r.appspot.com/v1/apps/users/pictures
//        //if !reachabilityManager.isConnection { completion(APIError.noInternet); return }
//        
//        let method = MethodAPI()
//        method.path = "users/pictures"
//        method.method = .patch
//        method.parameters = nil
//        method.headers = MethodAPI.bearerHeader()
//        method.printInfo()
//        
//        guard let imageData = image.toJPEGData(1),
//              let urlRequest = try? URLRequest(url: method.fullPath(), method: method.method, headers: method.headers) else {
//            onResult(.failure(APIError.custom("no imageData"))); return }
//        
//        AF.upload(multipartFormData: { multiPart in
//            multiPart.append(imageData, withName: "picture", fileName: "picture", mimeType: "image/png")
//        }, with: urlRequest)
//        .uploadProgress { progress in
//            print("Upload Progress: \(progress.fractionCompleted)")
//            progressHandler(progress.fractionCompleted)
//        }
//        .responseJSON { response in
//            let statusCode = response.response?.statusCode ?? 0
//            switch response.result {
//            case .success(let responseObject):
//                switch statusCode {
//                case 200: onResult(.success(""))
//                case 401:
//                    API.refreshToken { (error) in
//                        if let error = error {
//                            print("not update by refresh token: \(error.text)")
//                            onResult(.failure(.invalidAuth))
//                            return
//                        }
//                        RouteAPI.userPhoto_upload(image) { (progress) in
//                            progressHandler(progress)
//                        } onResult: { (result) in onResult(result) }
//
//                        //method.headers = ["Content-Type": "application/json",
//                        //                  "Authorization": "Bearer \(appService.tokenAccess)"]
//                        //self.request(method) { (route) in closure(route) }
//                    }
//                default: onResult(.failure(.custom("error upload with code \(statusCode)")))
//                }
//                printJSONString(responseObject, "uploadPhoto")
//            case .failure(let error):
//                print("Upload error statusCode: \(statusCode)")
//                onResult(.failure(.custom(error.localizedDescription)))
//            }
//        }
//    }
//}
