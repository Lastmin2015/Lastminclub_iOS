//
//  AuthViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.03.2021.
//

import UIKit
import AuthenticationServices //AppleSignIn

class AuthViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var appleButton: UIButton_auth!
    // MARK: - IBAction
    @IBAction func authButtonPressed(_ sender: UIButton) { auth(sender.tag) }
    // MARK: - Variables
    
    // MARK: - LifeCycle
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_GoogleAuth()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Screen.lockOrientation(.portrait, andRotateTo: .portrait)
        setNeedsStatusBarAppearanceUpdate()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Screen.lockOrientation(.all)
    }
    
    // MARK: - setupFormData
    private func setupFormData() {
    }
    
    // MARK: - Actions
    private func auth(_ tag: Int) {
        dismissKeyboard()
        switch tag {
        case 1: auth_apple()
        case 2: auth_fb()
        case 3: GoogleAuthHelper.signIn()
        case 4: goToAuthEmailVC()
        default: break
        }
    }
//    // test
//    private func activeAuth() {
//        appService.user = User.demo()
//        (self.tabBarController as? UITabBarController_app)?.setupFormData()
////        self.tabBarController?.viewControllers?.forEach {
////            print($0)
////        }
////        self.tabBarController?.viewControllers?.remove(at: 4)
//    }

    // MARK: - SetupUI
    private func setupUI() {
        appleButton.isHidden = !AppleAuthHelper.isAvailable()
    }

    // MARK: - Navigation
    private func goToAuthEmailVC() {
        let vc: EmailViewController = UIStoryboard.controller(.auth)
        pushVC(vc)
    }
//    private func goToApp() {
//        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
//        DispatchQueue.main.async { self.present(vc) }
//    }
//    private func goToAppleEmailVC() {
//        let vc: AppleEmailViewController = UIStoryboard.controller(.auth)
//        vc.email = "as@mail.com"
//        pushVC(vc)
//    }
}

// MARK: - API
extension AuthViewController {
    internal func auth_social(_ typeAuth: TypeAuth, _ token: String, _ email: String?) {
        print("success auth \(typeAuth.rawValue) token: \(token) email: \(email ?? "nil")")
        self.hudShow()
        API.auth_social(typeAuth, token, email) { [weak self] (result) in
            guard let sSelf = self else { return }
            sSelf.hudHide()
            switch result {
            case .failure(let error): error.run(sSelf)
            case .success(let tokens):
                print("accessToken: \(tokens.tokenAccess)")
                appService.token_save(tokens)
                //LocallyData.save_ktypeAuth()
                sSelf.finishAuth()
            }
        }
    }
    private func finishAuth() {
        self.hudShow()
        API.load_Data_User { [weak self] (error) in
            guard let sSelf = self else { return }
            sSelf.hudHide()
            if let error = error { error.run(sSelf); return }
            
            (sSelf.tabBarController as? UITabBarController_app)?.setupFormData(0)
            //sSelf.goToApp()
        }
    }
}
