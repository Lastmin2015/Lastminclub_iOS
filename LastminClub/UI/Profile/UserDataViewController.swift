//
//  UserDataViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 02.04.2021.
//

import UIKit
import InputMask

class UserDataViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passportNumberTextField: UITextField!
    @IBOutlet weak var passportCountryLabel: UILabel!
    @IBOutlet weak var passportDateExpTextField: UITextField!
    @IBOutlet var menuViewList: [UIView]!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    @IBAction func saveButtonPressed(_ sender: UIButton) { saveData() }
    // MARK: - Variables - UI
    let birthdatePicker = UIDatePicker()
    let passportDateExpPicker = UIDatePicker()
    var maskDelegate: MaskedTextFieldDelegate? = nil
    // MARK: - Variables
    var item: User!
    var didUpdate: (()->Void)?
    //
    //var newCountry: String = ""
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTapAround()
        setupTextField()
        setupInputMask()
        setupDatePicker()
        setupTapGestureRecognizer()
        setupFormData()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Screen.lockOrientation(.portrait, andRotateTo: .portrait)
        //setupFormData_dataUser()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Screen.lockOrientation(.all)
    }
    
    // MARK: - setupFormData
    private func setupFormData() {
        setupFormData_typeUser()
        setupFormData_dataUser()
    }
    private func setupFormData_typeUser() {
        backButton.setTitle(item.isUserApp ? "Profile" : "Co-Travellers", for: .normal)
        headerLabel.text = item.isUserApp ? "Personal Data" : (item.fullname.isEmpty ? "Add new" : item.fullname)
    }
    private func setupFormData_dataUser() {
        nameLabel.text = item.fullname
        birthdateTextField.text = item.birthdate?.toString(df1_ddMMyyyy)
        emailTextField.text = item.email
        phoneTextField.text = item.phone
        // Passport
        passportNumberTextField.text = item.passport?.number
        passportCountryLabel.text = item.passport?.country
        passportDateExpTextField.text = item.passport?.dateExp?.toString(df1_ddMMyyyy)
        //newCountry = item.passport?.country ?? ""
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
    }

    // MARK: - Navigation
//    private func goToCountryListVC() {
//        let vc: CountryListViewController = UIStoryboard.controller(.directory)
//        vc.didSelect = { (value) in
//            self.passportCountryLabel.text = value
//            //self.newCountry = value
//            DispatchQueue.main.async {
//
//            }
//
//        }
//        self.pushVC(vc)
//    }
}

// MARK: - UITextFieldDelegate
extension UserDataViewController: UITextFieldDelegate {
    private func setupTextField() {
        birthdateTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        passportNumberTextField.delegate = self
        passportDateExpTextField.delegate = self
        
        birthdateTextField.inputView = birthdatePicker
        birthdateTextField.addInputAccessoryView_cancelDone(target: self, selectorCancel: #selector(tapDate_Cancel), selectorDone: #selector(tapDone_dismissKeyboard))
        emailTextField.addInputAccessoryView_cancelDone(target: self, selectorCancel: #selector(tapEmail_Cancel), selectorDone: #selector(tapDone_dismissKeyboard))
        phoneTextField.addInputAccessoryView_cancelDone(target: self, selectorCancel: #selector(tapPhone_Cancel), selectorDone: #selector(tapDone_dismissKeyboard))
        passportNumberTextField.addInputAccessoryView_cancelDone(target: self, selectorCancel: #selector(tapPassportNumber_Cancel), selectorDone: #selector(tapDone_dismissKeyboard))
        passportDateExpTextField.inputView = passportDateExpPicker
        passportDateExpTextField.addInputAccessoryView_cancelDone(target: self, selectorCancel: #selector(tapPassportDateExp_Cancel), selectorDone: #selector(tapPassportDateExp_Done))
    }
    @objc func tapDone_dismissKeyboard() { dismissKeyboard() }
    @objc func tapDate_Cancel() {
        dismissKeyboard()
        birthdateTextField.text = item.birthdate?.toString(df1_ddMMyyyy)
    }
    @objc func tapEmail_Cancel() {
        dismissKeyboard()
        emailTextField.text = item.email
    }
    @objc func tapPhone_Cancel() {
        dismissKeyboard()
        phoneTextField.text = item.phone
    }
    @objc func tapPassportNumber_Cancel() {
        dismissKeyboard()
        passportNumberTextField.text = item.passport?.number
    }
    @objc func tapPassportDateExp_Cancel() {
        dismissKeyboard()
        //passportDateExpTextField.text = item.birthdate?.toString(df1_ddMMyyyy)
    }
    @objc func tapPassportDateExp_Done() {
        dismissKeyboard()
        //API save date
        //item.birthdate = passportDateExpPicker.date
        //passportDateExpTextField.text = item.birthdate?.toString(df1_ddMMyyyy)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField: dismissKeyboard()
        case phoneTextField: dismissKeyboard()
        case passportNumberTextField: dismissKeyboard()
        default: ()
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case birthdateTextField:
            guard textField.isEmpty else { return }
            textField.text = birthdatePicker.date.toString(df1_ddMMyyyy)
        case passportDateExpTextField:
            guard textField.isEmpty else { return }
            textField.text = passportDateExpPicker.date.toString(df1_ddMMyyyy)
        default: break
        }
    }
}

// MARK: - MaskedTextFieldDelegateListener
extension UserDataViewController: MaskedTextFieldDelegateListener {
    private func setupInputMask() {
        maskDelegate = MaskedTextFieldDelegate(primaryFormat: InputMaskHelper.mainMask)
        //maskDelegate?.put(text: "+7 ", into: loginFld)
        maskDelegate?.listener = self
        phoneTextField.delegate = maskDelegate
    }
}

// MARK: - DatePicker
extension UserDataViewController {
    internal func setupDatePicker() {
        //
        if #available(iOS 13.4, *) { birthdatePicker.preferredDatePickerStyle = .wheels }
        birthdatePicker.datePickerMode = .date
        birthdatePicker.locale = Locale.current//.init(identifier: "Russian")
        birthdatePicker.date = (item.birthdate == nil) ? (("01/03/1980".toDate(df1_ddMMyyyy) ?? Date()).startOfDay()) : item.birthdate!
        birthdatePicker.maximumDate = Date()
        birthdatePicker.addTarget(self, action: #selector(dateChanged_birthdatePicker), for: .valueChanged)
        //
        if #available(iOS 13.4, *) { passportDateExpPicker.preferredDatePickerStyle = .wheels }
        passportDateExpPicker.datePickerMode = .date
        passportDateExpPicker.locale = Locale.current
        passportDateExpPicker.date = (item.passport?.dateExp == nil) ? (Date().addMonth(60).startOfDay()) : item.passport!.dateExp!
        passportDateExpPicker.minimumDate = Date()
        passportDateExpPicker.addTarget(self, action: #selector(dateChanged_passportDateExpPicker), for: .valueChanged)
    }
    @objc func dateChanged_birthdatePicker() {
        birthdateTextField.text = birthdatePicker.date.toString(df1_ddMMyyyy)
    }
    @objc func dateChanged_passportDateExpPicker() {
        passportDateExpTextField.text = passportDateExpPicker.date.toString(df1_ddMMyyyy)
    }
}

// MARK: - setupTapGestureRecognizer_
extension UserDataViewController {
    private func setupTapGestureRecognizer() {
        menuViewList.forEach { $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap_menuView))) }
    }
    @objc private func tap_menuView(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let tag = gestureRecognizer.view?.tag else { return }
        switch tag {
        case 1:
            let vc: UserNameViewController = UIStoryboard.controller(.profile)
            vc.item = item
            vc.didUpdate = { self.nameLabel.text = self.item.fullname }
            self.pushVC(vc)
        case 2: birthdateTextField.becomeFirstResponder()
        case 32: //goToCountryListVC()
            let vc: CountryListViewController = UIStoryboard.controller(.directory)
            vc.didSelect = { (value) in
                self.passportCountryLabel.text = value
            }
            self.pushVC(vc)
        default: ()
        }
    }
}

// MARK: - API
extension UserDataViewController {
    private func saveData() {
        dismissKeyboard()
        
        var dict: [String: Any] = [:]
        // personal data
        if let date = birthdateTextField.textStr.toDate(df1_ddMMyyyy), date != item.birthdate {
            dict["birthday"] = date.toString(dF5_yyyyMMddTHHmmssZ)
        }
        if let email = emailTextField.text, email != item.email {
            dict["email"] = email
        }
        if let phone = phoneTextField.text, phone != item.phone {
            dict["phone"] = phone
        }
        // passport
        let pNumber = passportNumberTextField.text ?? ""
        let pCountry = passportCountryLabel.text ?? ""
        let pDateExpStr = passportDateExpTextField.text ?? ""
        let pDateExp = pDateExpStr.toDate(df1_ddMMyyyy)
        let pDateExtStrB = pDateExp?.toString(dF5_yyyyMMddTHHmmssZ) ?? ""
        let newPassport = Passport(number: pNumber, country: pCountry, dateExpStr: pDateExtStrB)
        if newPassport != item.passport, let dictP = newPassport.values {
            dict["passport"] = dictP
        }
        
        guard !dict.isEmpty else { self.popVC(); return }
        
        self.hudShow()
        API.userUpdate(dict) { [weak self] error in
            guard let sSelf = self else { return }
            sSelf.hudHide()
            if let error = error { error.run(sSelf); return }
            // personal data
            if let date = sSelf.birthdateTextField.textStr.toDate(df1_ddMMyyyy) {
                sSelf.item.birthdateStr = date.toString(dF5_yyyyMMddTHHmmssZ)
            }
            sSelf.item.email = sSelf.emailTextField.textStr
            sSelf.item.phone = sSelf.phoneTextField.textStr
            // passport
            if newPassport != sSelf.item.passport {
                sSelf.item.passport?.number = newPassport.number
                sSelf.item.passport?.country = newPassport.country
                sSelf.item.passport?.dateExpStr = newPassport.dateExpStr
            }
            
            sSelf.didUpdate?()
            sSelf.popVC(false)
        }
        
    }
}
