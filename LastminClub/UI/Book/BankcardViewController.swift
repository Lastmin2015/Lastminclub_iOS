//
//  BankcardViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 27.04.2021.
//

import UIKit

class BankcardViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var numberTextField: UITextField!
    //@IBOutlet weak var holderTextField: UITextField!
    @IBOutlet weak var expiryTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var postcodeTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    @IBAction func saveButtonPressed(_ sender: UIButton) { saveItem() }
    // MARK: - Variables
    var item: Bankcard!
    var didSave: ((Bankcard)->Void)?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        numberTextField.text = item.number
        expiryTextField.text = item.expiry
        cvvTextField.text = item.expiry
        postcodeTextField.text = item.postcode
        
        if appService.isDebug {
            numberTextField.text = "5101 2677 6689 0380"
            expiryTextField.text = "03/21"
            cvvTextField.text = "888"
            postcodeTextField.text = "1009"
        }
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
        setupUI_saveButton()
    }
    private func setupUI_saveButton() {
        let titleButton = isValidData() ? "Save" : "Cancel"
        saveButton.setTitle(titleButton, for: .normal)
    }

    // MARK: - Navigation
    private func goToVC() {
        //let vc: PswViewController = UIStoryboard.controller(.auth)
        //vc.email = Validator().email_clear(emailTextField.text)
        //self.pushVC(vc)
    }
}

// MARK: - UITextFieldDelegate
extension BankcardViewController: UITextFieldDelegate {
    private func setupTextField() {
        numberTextField.delegate = self
        expiryTextField.delegate = self
        cvvTextField.delegate = self
        postcodeTextField.delegate = self
        
        numberTextField.addInputAccessoryView(title: "Done", target: self, selector: #selector(tapDone))
        expiryTextField.addInputAccessoryView(title: "Done", target: self, selector: #selector(tapDone))
        cvvTextField.addInputAccessoryView(title: "Done", target: self, selector: #selector(tapDone))
        postcodeTextField.addInputAccessoryView(title: "Done", target: self, selector: #selector(tapDone))
    }
    @objc func tapDone() { dismissKeyboard() }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case numberTextField: expiryTextField.becomeFirstResponder()
        case expiryTextField: cvvTextField.becomeFirstResponder()
        case cvvTextField: postcodeTextField.becomeFirstResponder()
        case postcodeTextField: dismissKeyboard()
        default: dismissKeyboard()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count
        //
        let char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92) { textField.text!.removeLast(); return false }
        //
        let lastText = (text as NSString).replacingCharacters(in: range, with: string) as String
        
        if textField == numberTextField {
            textField.text = lastText.format("nnnn nnnn nnnn nnnn", oldString: text)
            return false
        } else if textField == expiryTextField {
            //textField.text = lastText.format("NN/NN", oldString: text)
            //return false
            
            if count == 5 { return false }
            else if count == 0 { return ["0", "1"].contains(string) }
            else if count == 1 {
                if let month = Int("\(text)\(string)") { return (month <= 12) }
                else { return false }
            } else if [2].contains(count) { textField.text = "\(text)/" }
        } else if textField == cvvTextField {
            textField.text = lastText.format("NNN", oldString: text)
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //guard let textField = textField as? UITextField else { return }
        switch textField {
        case numberTextField: ()
            //let isValid = CreditCardValidator.isValidCardNumber(textField.textStr)
            //textField.updateState(isValid ? .valid : .invalid, withMessage: "")
            //numberSuccessImageView.isHidden = !isValid
            //setupUI_typeCard()
//        case holderTextField:
//            let isValid = CreditCardValidator.isValidCardHolder(textField.textStr)
//            textField.updateState(isValid ? .valid : .invalid, withMessage: "")
        case expiryTextField: ()
            //let isValid = CreditCardValidator.isValidCardDate(textField.textStr)
            //textField.updateState(isValid ? .valid : .invalid, withMessage: "")
        case cvvTextField: ()
            //let isValid = CreditCardValidator.isValidCardCVV(textField.textStr)
            //textField.updateState(isValid ? .valid : .invalid, withMessage: "")
        default: ()
        }
        setupUI_saveButton()
        //nextButton.setLock(!isValidData())
        //nextButton.setStateBtn(isValidData() ? .on : .inac)
    }
}

// MARK: - API
extension BankcardViewController {
    private func isValidData() -> Bool {
        var isValid: Bool = true
        
        let isValidCardNumber = CreditCardValidator.isValidCardNumber(numberTextField.textStr)
        //let isValidCardHolder = CreditCardValidator.isValidCardHolder(holderTextField.textStr)
        let isValidCardExpiry = CreditCardValidator.isValidCardDate(expiryTextField.textStr)
        let isValidCardCVV = CreditCardValidator.isValidCardCVV(cvvTextField.textStr)

        if !isValidCardNumber { isValid = false }
        //if !isValidCardHolder { isValid = false }
        if !isValidCardExpiry { isValid = false }
        if !isValidCardCVV { isValid = false }

        return isValid
    }
    private func saveItem() {
        dismissKeyboard()
        guard isValidData() else { popVC(); return }
        
        item.id = UUID().uuidString
        item.number = numberTextField.textStr
        item.expiry = expiryTextField.textStr
        item.cvv = cvvTextField.textStr
        item.postcode = postcodeTextField.textStr
        
        self.didSave?(item)
        self.popVC(false)
    }
}
