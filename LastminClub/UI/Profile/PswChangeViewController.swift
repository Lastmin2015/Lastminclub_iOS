//
//  PswChangeViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 06.04.2021.
//

import UIKit

class PswChangeViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var psw0TextField: UITextField!
    @IBOutlet weak var psw1TextField: UITextField!
    @IBOutlet weak var psw2TextField: UITextField!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    @IBAction func saveButtonPressed(_ sender: UIButton) { saveData() }
    @IBAction func recoveryPswButtonPressed(_ sender: UIButton) { goToRecoveryPswVC() }
    // MARK: - Variables
    var didUpdate: (()->Void)?
    
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
    }
    
    // MARK: - SetupUI
    private func setupUI() {
    }
    
    // MARK: - Navigation
    private func goToRecoveryPswVC() {
        let vc: RecoveryPswViewController = UIStoryboard.controller(.auth)
        vc.email = appService.user?.email ?? ""
        self.pushVC(vc)
    }
}

// MARK: - UITextFieldDelegate
extension PswChangeViewController: UITextFieldDelegate {
    private func setupTextField() {
        psw0TextField.delegate = self
        psw1TextField.delegate = self
        psw2TextField.delegate = self
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case psw0TextField: psw1TextField.becomeFirstResponder()
        case psw1TextField: psw2TextField.becomeFirstResponder()
        case psw2TextField: saveData()
        default: ()
        }
        return true
    }
}

// MARK: - API
extension PswChangeViewController {
    private func isValidData(_ isShowAlert: Bool = false) -> Bool {
        var isValid: Bool = true
        var textError = ""
        //
        let psw = psw1TextField.textStr
        let isValid1 = Validator().isValidPassword_minCount(psw)
        let isValid2 = Validator().isValidPassword_includeNumber(psw)
        let isValid3 = Validator().isValidPassword_lowercaseLetter(psw)
        let isValid4 = Validator().isValidPassword_uppercaseLetter(psw)
        let isMatch = (psw1TextField.textStr == psw2TextField.textStr)
        //
        if psw0TextField.isEmpty {
            isValid = false
            textError = "Enter current password"
        } else if psw1TextField.isEmpty {
            isValid = false
            textError = "Enter new password"
        } else if psw2TextField.isEmpty {
            isValid = false
            textError = "Enter confirm password"
        } else if !(isValid1 && isValid2 && isValid3 && isValid4) {
            isValid = false
            textError = "New password is not correct"
        } else if !isMatch {
            isValid = false
            textError = "Password mismatch"
        }
        //
        if isShowAlert && !isValid && !textError.isEmpty { self.displayAlert("Warning", textError) }

        return isValid
    }
    private func saveData() {
        dismissKeyboard()
        guard isValidData(true) else { return }
        
        var dict: [String: Any] = [:]
        dict["old_password"] = psw0TextField.textStr
        dict["new_password"] = psw2TextField.textStr
        
        self.hudShow()
        API.userPws_update(dict) { [weak self] (error) in
            guard let sSelf = self else { return }
            sSelf.hudHide()
            if let error = error { error.run(sSelf); return }
            
            sSelf.didUpdate?()
            sSelf.popVC(false)
        }
    }
}
