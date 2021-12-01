//
//  FaceBookHelper.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.03.2021.
//

import FBSDKCoreKit
import FBSDKLoginKit

class FacebookHelper {}

// MARK: - handled
extension FacebookHelper {
    static func configureApp(_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    static func handledFacebook(_ app: UIApplication, url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handledFacebook: Bool = ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
        return handledFacebook
    }
    static func handledFacebookIOS13(_ url: URL) {
        ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: nil, annotation: [UIApplication.OpenURLOptionsKey.annotation])
    }
}

// MARK: - Auth
extension FacebookHelper {
    static func auth(_ vc: UIViewController, onResult: @escaping (Result<String, ErrorApp>)->()) {
        if let accessToken = AccessToken.current, !accessToken.isExpired
        { onResult(.success(accessToken.tokenString)); return }
        
        let manager = LoginManager()
        let params: [Permission] = [.publicProfile, .email]
        //params += [.userBirthday, .userGender, .userPhotos]
        manager.logIn(permissions: params, viewController: vc) { (result) in
            switch result {
            case .cancelled: onResult(.failure(.errorApp("Вы отменили авторизацию")))
            case .failed(let error): onResult(.failure(.errorApp(error.localizedDescription)))
            case .success(let granted, let declined, let accessToken):
                print(granted, declined, accessToken.tokenString, accessToken.userID)
                onResult(.success(accessToken.tokenString))
            }
        }
    }
    static func getUserInfo(_ token: String, onResult: @escaping (Result<[String: Any], ErrorApp>)->()) {
        //let token = AccessToken.current?.tokenString
        //id, email, name, picture.type(large)
        let params = ["fields": "email, first_name, last_name"]//, gender, picture"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params, tokenString: token, version: nil, httpMethod: .get)
        
        graphRequest.start { (connection, result, error) in
            if let error = error
            { onResult(.failure(.errorApp(error.localizedDescription))); return }
            guard let json = result as? [String: Any]
            else { onResult(.failure(.invalidJSON("FB: getUserInfo"))); return }
            
            print("Facebook graph request successful!")
            printJSONString(json, "getUserInfo FB")
            
//            let email = json["email"] as? String ?? ""
//            let name = json["first_name"] as? String ?? ""
//            let surname = json["last_name"] as? String ?? ""
//            let idFB = json["id"] as? String ?? ""
//
//            print("FacebookAuth: User Id: \(idFB) \n name: \(name) \n surname: \(surname) \n email: \(email) \n token: \(token)")
            
            var dict: [String: String] = [:]
            dict["email"] = json["email"] as? String
            dict["name"] = json["first_name"] as? String
            dict["surname"] = json["last_name"] as? String
            dict["idFB"] = json["id"] as? String ?? ""
            
            onResult(.success(dict))
        }
    }
    //
    static func logOut() { LoginManager().logOut() }
}

// MARK: - FaceBook
extension AuthViewController {
    internal func auth_fb() {
        self.hudShow()
        FacebookHelper.auth(self) { [weak self] (result) in
            guard let sSelf = self else { return }
            sSelf.hudHide()
            switch result {
            case .failure(let error): error.run(sSelf)
            case .success(let token):
                sSelf.hudShow()
                FacebookHelper.getUserInfo(token) { (result) in
                    sSelf.hudHide()
                    switch result {
                    case .failure(let error): error.run(sSelf)
                    case.success(let json):
                        printJSONString(json, "getUserInfo")
                        //guard let email = json["email"] as? String else {
                        //    ErrorApp.custom("not have email").run(sSelf)
                        //    return
                        //}
                        let email = json["email"] as? String
                        sSelf.auth_social(.facebook, token, email)
                    }
                }
            }
        }
    }
}
