//
//  GoogleAuthHelper.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 27.03.2021.
//

import Foundation
import GoogleSignIn

class GoogleAuthHelper {
    static let clientId = "665753782585-j6udjq6gsip5c3ifc9htv3g9ea4p9bu2.apps.googleusercontent.com"
}

// MARK: - configureApp
extension GoogleAuthHelper {
    static func configureApp() {
        GIDSignIn.sharedInstance().clientID = GoogleAuthHelper.clientId
    }
    static func handledGoogle(_ app: UIApplication, url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    //
    static func signIn() { GIDSignIn.sharedInstance()?.signIn() }
}

// MARK: - AuthViewController
//https://developers.google.com/identity/sign-in/ios/sign-in?authuser=7&ver=swift
extension AuthViewController: GIDSignInDelegate {
    internal func setup_GoogleAuth() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        //GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    // GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else { print("\(error.localizedDescription)") }
            return
        }
        
        guard let token = user.authentication.idToken else { return }
        print("google auth: \(user)")
        let email = user.profile.email
        auth_social(.google, token, email)
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        print("Error GIDSignIn: \(error.localizedDescription)")
    }
}

/*
 https://coderoad.ru/42434887/Google-%D0%B2%D0%BE%D0%B9%D0%B4%D0%B8%D1%82%D0%B5-%D0%B2-%D1%81%D0%B5%D1%80%D0%B2%D0%B5%D1%80-%D0%B0%D0%B2%D1%82%D0%BE%D1%80%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D0%B8-%D0%BA%D0%BE%D0%B4-%D0%BD%D0%B5-%D0%BF%D1%80%D0%BE%D0%BF%D1%83%D1%81%D1%82%D0%B8%D1%82-iOS
 */
