//
//  ErrorApp.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.03.2021.
//

import UIKit

public enum ErrorApp: Error, Equatable {
    case custom(String)
    case errorApp(String)
    case invalidJSON(String)
    case noInternet
    case refreshToken
    case invalidAuth
    //
}

extension ErrorApp: LocalizedError {
    public var text: String {
        switch self {
        case .custom(let text): return text
        case .errorApp(let text): return text
        case .invalidJSON: return "Invalid JSON"
        case .noInternet: return "No internet connection"
        case .refreshToken: return "Unauthorized"
        case .invalidAuth: return "Invalid Auth"
        }
    }
}

extension ErrorApp {
    func run(_ vc: UIViewController) {
        var textAlert: String = ""
        switch self {
        case .invalidAuth:
            ()//QW-?
//            let authVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "navAuthVC") as! UINavigationController
//            DispatchQueue.main.async { vc.present(authVC) }
        case .custom, .invalidJSON:
            textAlert = "An error has occurred, please try again later"
            textAlert += "\n\(self.text)"//QWdev
            print("ERROR custom: \(self.text)")
        case .errorApp, .noInternet, .refreshToken: textAlert = self.text
        //case .auth_needReg: textAlert = self.text
        }
        DispatchQueue.main.async { vc.displayAlert("", textAlert) }
    }
    //
    static func setup(_ route: RouteAPI) -> ErrorApp {
        let statusCode = route.statusCode
        var text: String = "\n====================\n"
        
        if let method = route.method {
            let path = method.path.components(separatedBy: "?").first ?? ""
            text += "\(path)"
            text += "\n"
        }
        text += "statusCode: \(statusCode)"
        text += "\n"
        if let msg = route.dict["message"] as? String { text += msg }
        else if let errorDict = route.dict["error"] as? [String: Any],
                  let msg = errorDict["message"] as? String {
            text += msg
        }
        
        return .custom(text)
    }
}
