//
//  RecoveryPswViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 31.03.2021.
//

import UIKit

class RecoveryPswViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    @IBAction func nextButtonPressed(_ sender: UIButton) { recoveryPsw() }
    // MARK: - Variables
    var email: String = ""
    var didSendLink: (()->Void)?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTapAround()
        setupTextField()
        setupFormData()
        setupUI()
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
        emailTextField.text = email
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
    }

    // MARK: - Navigation
}

// MARK: - UITextFieldDelegate
extension RecoveryPswViewController: UITextFieldDelegate {
    private func setupTextField() {
        emailTextField.delegate = self
        emailTextField.setLeftPadding(100)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField: recoveryPsw()
        default: ()
        }
        return true
    }
}

// MARK: - API
extension RecoveryPswViewController {
    private func isValidData(_ isShowAlert: Bool = false) -> Bool {
        var isValid: Bool = true
        var textError = ""
        
        if let error = Validator().isValidEmail(emailTextField.textStr) {
            isValid = false
            textError += error
        }
        
        if isShowAlert && !isValid { self.displayAlert("Warning", textError) }

        return isValid
    }
    
    private func recoveryPsw() {
        dismissKeyboard()
        guard isValidData(true) else { return }
        let email = Validator().email_clear(emailTextField.text)
        
        self.hudShow()
        API.pswRecovery(email) { [weak self] (error) in
            guard let sSelf = self else { return }
            sSelf.hudHide()
            if let error = error { error.run(sSelf); return }
            sSelf.displayAlertCompletion("", "An email has been sent to your email with a link to reset your password. Check your mailbox.") {
                sSelf.didSendLink?()
                sSelf.popVC(false)
            }
        }
        
        
//        var dict: [String: Any] = [:]
//        dict["email"] = Validator().email_clear(emailTextField.text)
//        dict["password"] = pswTextField.textStr
//
//        self.hudShow()
//        API.auth_email(dict) { [weak self] (result) in
//            guard let sSelf = self else { return }
//            sSelf.hudHide()
//            switch result {
//            case .failure(let error): error.run(sSelf)
//            case .success((let accessToken, let refreshToken)):
//                print("accessToken: \(accessToken)")
//                appService.token_save(accessToken, refreshToken)
//                YMMHelp.sendEvent(.login_email)
//                //LocallyData.save_ktypeAuth(.email)
//                sSelf.finishAuth()
//            }
//        }
    }
}
