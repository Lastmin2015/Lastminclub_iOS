//
//  Validator.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 31.03.2021.
//

import UIKit

struct Validator {
    public enum TypeData {
        case phone
        case email
        case psw
        case simple
        
        var name: String {
            switch self {
            case .phone: return "телефон"
            case .email: return "email"
            case .psw: return "пароль"
            case .simple: return ""
            }
        }
    }
}

// MARK: Variables
extension Validator {
    func isValidData(_ typeData: TypeData, _ data: String?) -> String? {
        guard let data = data, !data.isEmpty else {
            switch typeData {
            case .phone, .email, .psw: return "Enter \(typeData.name)"
            default: return "Заполните \(typeData.name)"
            }
        }
        
        switch typeData {
        case .phone: return isValidPhone(data)
        case .email: return isValidEmail(data)
        case .psw: return isValidPassword(data)
        case .simple: return nil
        }
    }
    
    // MARK: phone
    func isValidPhone(_ phone: String) -> String? {
        guard !phone_isValid(phone) else { return nil }
        return "Длина цифрового поля номера должна быть 11."
//        let errorText = "Некорректный телефон"
//        let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
//        guard let detector = try? NSDataDetector(types: types.rawValue) else { return errorText }
//        if let match = detector.matches(in: phone, options: [], range: NSMakeRange(0, phone.count)).first?.phoneNumber {
//            return (match == phone) ? nil : errorText
//        } else { return errorText }
    }//https://stackoverflow.com/questions/27998409/email-phone-validation-in-swift
    func phone_clear(_ phone: String?) -> String {
        guard let phone = phone else { return "" }
        return phone.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "*", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "+", with: "")
    }
    func phone_isValid(_ phone: String?) -> Bool {
        let phone = phone_clear(phone)
        return (phone.count == 11)
    }
    // MARK: email
    func isValidEmail(_ emailText: String) -> String? {
        let email = email_clear(emailText)
        guard !email.isEmpty else { return "Enter email" }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: email) ? nil : "Incorrect email"
    }
    func email_clear(_ email: String?) -> String { return email?.clearSpace().lowercased() ?? "" }
    // MARK: password
    func isValidPassword(_ psw: String) -> String? {
        let minCount = 8
        if !isValidPassword_minCount(psw) { return "Пароль должен состоять минимум из \(minCount) символов" }
        else if !isValidPassword_latinAlphabet(psw) { return "Пароль должен состоять из латинских букв" }
        else if !isValidPassword_uld(psw) { return "Пароль должен содержать заглавную, строчную буквы и цифру" }
        else { return nil }
    }
    func isValidPassword_minCount(_ psw: String) -> Bool {
        let minCount = 8
        return (psw.count >= minCount)
    }
    func isValidPassword_includeNumber(_ psw: String) -> Bool {
        //let numbersRange = psw.rangeOfCharacter(from: .decimalDigits)
        //return (numbersRange != nil)
        // or
        let numberRegEx  = ".*[0-9]+.*"
        let testCase     = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        return testCase.evaluate(with: psw)
    }
    func isValidPassword_lowercaseLetter(_ psw: String) -> Bool {
        let numberRegEx  = ".*[a-z]+.*"
        let testCase     = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        return testCase.evaluate(with: psw)
    }
    func isValidPassword_uppercaseLetter(_ psw: String) -> Bool {
        let numberRegEx  = ".*[A-Z]+.*"
        let testCase     = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        return testCase.evaluate(with: psw)
    }
    
    func isValidPassword_latinAlphabet(_ text: String) -> Bool {
        //guard !text.isEmpty else { return false }
        //^[0-9a-zA-Z!@#\$%^&*()\\\\-_=+{}|?>.<,:;~`']+\$
        //let regEx = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[@#$%^&*]).{8,}"
        //let regEx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        //let regEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{1,}$"
        let regEx = "^[A-Za-z0-9]{1,}$"
        let textTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        return textTest.evaluate(with: text)
    }
    func isValidPassword_uld(_ text: String) -> Bool {
        let regEx = "(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).*"
        let textTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        return textTest.evaluate(with: text)
    }
}

//// MARK: - UITextField_App
//extension Validator {
//    static func isValidDataTF(_ typeData: TypeData, _ textField: UITextField_App, _ simpleError: String? = nil) -> Bool {
//        var isValid: Bool = true
//
//        if let error = Validator().isValidData(typeData, textField.text) {
//            isValid = false
//            let textError = (simpleError != nil) ? simpleError! : error
//            textField.updateState(.invalid, withMessage: textError)
//        }
//
//        return isValid
//    }
//}
