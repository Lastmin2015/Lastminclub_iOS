//
//  EmailViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 27.03.2021.
//

import UIKit

class EmailViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    @IBAction func nextButtonPressed(_ sender: UIButton) { auth_email() }
    // MARK: - Variables
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTapAround()
        setupTextField()
        setupUI()
        
        // isDebug
        if appService.isDebug {
            emailTextField.text = "aazorin.rus@mail.ru"
            //emailTextField.text = "test0@mail.com"
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
    }

    // MARK: - Navigation
    private func goToPswVC(_ email: String) {
        let vc: PswViewController = UIStoryboard.controller(.auth)
        vc.email = email
        self.pushVC(vc)
    }
    private func goToCreatePswVC(_ email: String) {
        let vc: CreatePswViewController = UIStoryboard.controller(.auth)
        vc.email = email
        self.pushVC(vc)
    }
}

// MARK: - UITextFieldDelegate
extension EmailViewController: UITextFieldDelegate {
    private func setupTextField() {
        emailTextField.delegate = self
        emailTextField.setLeftPadding(100)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField: auth_email()
        default: ()
        }
        return true
    }
}

// MARK: - API
extension EmailViewController {
    private func isValidData(_ isShowAlert: Bool = false) -> Bool {
        var isValid: Bool = true
        var textError = ""
        
        if let error = Validator().isValidEmail(emailTextField.textStr) {
            isValid = false
            textError = error
        }
        
        if isShowAlert && !isValid { self.displayAlert("Warning", textError) }

        return isValid
    }
    
    private func auth_email() {
        dismissKeyboard()
        guard isValidData(true) else { return }
        let email = Validator().email_clear(emailTextField.text)
        
        self.hudShow()
        API.isExistEmail(email) { [weak self] (result) in
            guard let sSelf = self else { return }
            sSelf.hudHide()
            switch result {
            case .failure(let error): error.run(sSelf)
            case .success(let isExist):
                switch isExist {
                case true: sSelf.goToPswVC(email)
                case false: sSelf.goToCreatePswVC(email)
                }
            }
        }
    }
}
