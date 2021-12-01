//
//  AppleAuthHelper.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.03.2021.
//
/*
 https://developer.apple.com/documentation/authenticationservices/implementing_user_authentication_with_sign_in_with_apple
 */

import Foundation
import AuthenticationServices //AppleSignIn

class AppleAuthHelper {}

// MARK: - Auth
extension AppleAuthHelper {
    static func isAvailable() -> Bool {
        if #available(iOS 13.0, *) { return true } else { return false }
    }
}

// MARK: - AppleAuth //AppleSignIn
// https://appleid.apple.com/account/manage
@available(iOS 13.0, *)
extension AppleAuthHelper {
    static func authData(_ authorization: ASAuthorization) -> [String: Any]? {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            guard let identityTokenData = appleIDCredential.identityToken,
                  let tokenApple = String(data: identityTokenData, encoding: .utf8)
            else { return nil }
            
            var dict: [String: String] = [:]
            dict["email"] = appleIDCredential.email
            dict["name"] = appleIDCredential.fullName?.givenName
            dict["surname"] = appleIDCredential.fullName?.familyName
            dict["idApple"] = appleIDCredential.user
            dict["tokenApple"] = tokenApple
            
            return dict
        default: return nil
        }
    }
}

// MARK: - AppleAuth //AppleSignIn
// https://appleid.apple.com/account/manage
// MARK: - FaceBook
extension AuthViewController {
    internal func auth_apple() {
        guard AppleAuthHelper.isAvailable() else { return }
        if #available(iOS 13.0, *) { didTapAppleButton() }
    }
}

@available(iOS 13.0, *)
extension AuthViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @objc internal func didTapAppleButton() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func performExistingAccountSetupFlows() {
        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //guard let token = AppleAuthHelper.auth(authorization) else { return }
        //self.auth_social(.apple, token)
        //
        guard let json = AppleAuthHelper.authData(authorization),
              let token = json["tokenApple"] as? String
        else { return }
        let email = json["email"] as? String
        auth_social(.apple, token, email)
        printJSONString(json, "auth dict apple")
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error Apple SignIn: \(error.localizedDescription)")
    }
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
