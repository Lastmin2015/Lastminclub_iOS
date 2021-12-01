//
//  UserNameViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 02.04.2021.
//

import UIKit

class UserNameViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var patronymicTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    @IBAction func saveButtonPressed(_ sender: UIButton) { saveData() }
    // MARK: - Variables
    var item: User!
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
        nameTextField.text = item.name
        patronymicTextField.text = item.patronymic
        surnameTextField.text = item.surname
    }
    
    // MARK: - SetupUI
    private func setupUI() {
    }
}

// MARK: - UITextFieldDelegate
extension UserNameViewController: UITextFieldDelegate {
    private func setupTextField() {
        nameTextField.delegate = self
        patronymicTextField.delegate = self
        surnameTextField.delegate = self
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField: patronymicTextField.becomeFirstResponder()
        case patronymicTextField: surnameTextField.becomeFirstResponder()
        case surnameTextField: saveData()
        default: ()
        }
        return true
    }
}

// MARK: - API
extension UserNameViewController {
    private func saveData() {
        dismissKeyboard()
        if item.isUserApp { saveData_userApp() }
        else { saveData_coTravellers() }
    }
    private func saveData_userApp() {
        var dict: [String: Any] = [:]
        dict["first_name"] = nameTextField.textStr
        dict["middle_name"] = patronymicTextField.textStr
        dict["last_name"] = surnameTextField.textStr
        
        self.hudShow()
        API.userUpdate(dict) { [weak self] error in
            guard let sSelf = self else { return }
            sSelf.hudHide()
            if let error = error { error.run(sSelf); return }
            
            //appService.user?
            sSelf.item.name = sSelf.nameTextField.textStr
            sSelf.item.patronymic = sSelf.patronymicTextField.textStr
            sSelf.item.surname = sSelf.surnameTextField.textStr
            
            sSelf.didUpdate?()
            sSelf.popVC(false)
        }
    }
    private func saveData_coTravellers() {
        self.displayAlert("Not work", "in processing")
    }
}
