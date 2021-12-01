//
//  PswViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 31.03.2021.
//

import UIKit

class PswViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var pswTextField: UITextField!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    @IBAction func nextButtonPressed(_ sender: UIButton) { auth_email() }
    @IBAction func recoveryPswButtonPressed(_ sender: UIButton) { goToRecoveryPswVC() }
    // MARK: - Variables
    var email: String = ""
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTapAround()
        setupTextField()
        setupFormData()
        setupUI()
        
        // isDebug
        if appService.isDebug {
            pswTextField.text = "Zz12345678"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Screen.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Screen.lockOrientation(.all)
    }
    
    // MARK: - setupFormData
    private func setupFormData() {
        hintLabel.text = "Enter your Lastmin Club password for \(email)"
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
    }

    // MARK: - Navigation
    private func goToRecoveryPswVC() {
        let vc: RecoveryPswViewController = UIStoryboard.controller(.auth)
        vc.email = email
        vc.didSendLink = {
            self.pswTextField.text = nil
            self.pswTextField.becomeFirstResponder()
        }
        self.pushVC(vc)
    }
}

// MARK: - UITextFieldDelegate
extension PswViewController: UITextFieldDelegate {
    private func setupTextField() {
        pswTextField.delegate = self
        pswTextField.setLeftPadding(100)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case pswTextField: auth_email()
        default: ()
        }
        return true
    }
}

// MARK: - API
extension PswViewController {
    private func isValidData(_ isShowAlert: Bool = false) -> Bool {
        var isValid: Bool = true
        var textError = ""
        
        if pswTextField.isEmpty {
            isValid = false
            textError = "Enter password"
        }
        
        if isShowAlert && !isValid { self.displayAlert("Warning", textError) }

        return isValid
    }
    
    private func auth_email() {
        dismissKeyboard()
        guard isValidData(true) else { return }
        
        var dict: [String: Any] = [:]
        dict["email"] = email
        dict["password"] = pswTextField.textStr

        self.hudShow()
        API.auth_email(dict) { [weak self] (result) in
            guard let sSelf = self else { return }
            sSelf.hudHide()
            switch result {
            case .failure(let error): error.run(sSelf)
            case .success(let tokens):
                print("accessToken: \(tokens.tokenAccess)")
                appService.token_save(tokens)
//                //LocallyData.save_ktypeAuth(.email)
                sSelf.finishAuth()
//                sSelf.activeAuth()
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
    // test
//    private func activeAuth() {
//        appService.user = User.demo()
//        (self.tabBarController as? UITabBarController_app)?.setupFormData()
//    }
}
