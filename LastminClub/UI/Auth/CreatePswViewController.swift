//
//  CreatePswViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 31.03.2021.
//

import UIKit

class CreatePswViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var psw0TextField: UITextField!
    @IBOutlet weak var psw1TextField: UITextField!
    @IBOutlet weak var errorPsw1Label: UILabel!
    @IBOutlet weak var errorPsw1ImageView: UIImageView!
    @IBOutlet var checkImageViewList: [UIImageView]!
    @IBOutlet var checkLabelList: [UILabel]!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    @IBAction func nextButtonPressed(_ sender: UIButton) { reg_email() }
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
            psw0TextField.text = "Zz12345678"
            psw1TextField.text = "Zz12345678"
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
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
        setupUI_checkPsw(false)
        setupUI_errorPsw2(false)
    }
    private func setupUI_checkPsw(_ isCheck: Bool) {
        let psw = psw0TextField.textStr
        let isValid1 = Validator().isValidPassword_minCount(psw)
        let isValid2 = Validator().isValidPassword_includeNumber(psw)
        let isValid3 = Validator().isValidPassword_lowercaseLetter(psw)
        let isValid4 = Validator().isValidPassword_uppercaseLetter(psw)
        let defImage = UIImage(named: "checkbox_0")
        let defColor = hexToUIColor("3c3c43", 0.6)
        let check1Color = hexToUIColor("009d97")
        let check2Color = hexToUIColor("df248d")
        
        checkImageViewList.forEach {
            switch $0.tag {
            case 1: $0.image = isCheck ? UIImage(named: "checkbox_\(isValid1 ? 1 : 2)") : defImage
            case 2: $0.image = isCheck ? UIImage(named: "checkbox_\(isValid2 ? 1 : 2)") : defImage
            case 3: $0.image = isCheck ? UIImage(named: "checkbox_\(isValid3 ? 1 : 2)") : defImage
            case 4: $0.image = isCheck ? UIImage(named: "checkbox_\(isValid4 ? 1 : 2)") : defImage
            default: ()
            }
        }
        checkLabelList.forEach {
            switch $0.tag {
            case 1: $0.textColor = isCheck ? (isValid1 ? check1Color : check2Color) : defColor
            case 2: $0.textColor = isCheck ? (isValid2 ? check1Color : check2Color) : defColor
            case 3: $0.textColor = isCheck ? (isValid3 ? check1Color : check2Color) : defColor
            case 4: $0.textColor = isCheck ? (isValid4 ? check1Color : check2Color) : defColor
            default: ()
            }
        }
    }
    private func setupUI_errorPsw2(_ isShow: Bool) {
        errorPsw1Label.isHidden = !isShow
        errorPsw1ImageView.isHidden = !isShow
    }

    // MARK: - Navigation
    private func goToRecoveryPswVC() {
        let vc: RecoveryPswViewController = UIStoryboard.controller(.auth)
        vc.email = email
        self.pushVC(vc)
    }
}

// MARK: - UITextFieldDelegate
extension CreatePswViewController: UITextFieldDelegate {
    private func setupTextField() {
        psw0TextField.delegate = self
        psw1TextField.delegate = self
        
        psw0TextField.setLeftPadding(100)
        psw1TextField.setLeftPadding(190)
        
        psw0TextField.addTarget(self, action: #selector(self.didChange0), for: .editingChanged)
        psw1TextField.addTarget(self, action: #selector(self.didEditBegin1), for: .editingDidBegin)
        psw1TextField.addTarget(self, action: #selector(self.didEditEnd1), for: .editingDidEnd)
    }
    @objc private func didChange0() { setupUI_checkPsw(true) }
    @objc private func didEditBegin1() { setupUI_errorPsw2(false) }
    @objc private func didEditEnd1() {
        let isMatch = (psw0TextField.textStr == psw1TextField.textStr)
        setupUI_errorPsw2(!isMatch)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case psw0TextField: psw1TextField.becomeFirstResponder()
        case psw1TextField: reg_email()
        default: ()
        }
        return true
    }
}

// MARK: - API
extension CreatePswViewController {
    private func isValidData(_ isShowAlert: Bool = false) -> Bool {
        var isValid: Bool = true
        var textError = ""
        
        if psw0TextField.isEmpty {
            isValid = false
            textError = "Enter password"
        }
        if psw1TextField.isEmpty {
            isValid = false
            textError = "Enter confirm password"
        }
        //
        let psw = psw0TextField.textStr
        let isValid1 = Validator().isValidPassword_minCount(psw)
        let isValid2 = Validator().isValidPassword_includeNumber(psw)
        let isValid3 = Validator().isValidPassword_lowercaseLetter(psw)
        let isValid4 = Validator().isValidPassword_uppercaseLetter(psw)
        let isMatch = (psw0TextField.textStr == psw1TextField.textStr)
        
        if !(isValid1 && isValid2 && isValid3 && isValid4) {
            setupUI_checkPsw(true)
            isValid = false
        }
        if !isMatch { setupUI_errorPsw2(!isMatch); isValid = false }
        //
        
        if isShowAlert && !isValid && !textError.isEmpty { self.displayAlert("Warning", textError) }

        return isValid
    }
    
    private func reg_email() {
        dismissKeyboard()
        guard isValidData(true) else { return }
        
        var dict: [String: Any] = [:]
        dict["email"] = email
        dict["password"] = psw0TextField.textStr

        self.hudShow()
        API.reg_email(dict) { [weak self] (result) in
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
