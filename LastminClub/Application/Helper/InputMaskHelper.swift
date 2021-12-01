//
//  InputMaskHelper.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 06.04.2021.
//

import InputMask

class InputMaskHelper {
    static let mainMask = "{+}[000] ([000]) [000] [00] [00]"
    
    static func formatPhoneToMask(_ phone: String?) -> String {
        guard let phone = phone else { return "" }
        let maskStr = InputMaskHelper.mainMask
        guard let mask: Mask = try? Mask(format: maskStr) else { return phone }
        let result: Mask.Result =
            mask.apply(toText: CaretString(string: phone, caretPosition: phone.endIndex, caretGravity: .forward(autocomplete: true)))
        let output: String = result.formattedText.string
        return output
    }
    static func formatPhoneToMask(_ phoneNum: Int?) -> String {
        guard let phoneNum = phoneNum else { return "" }
        return InputMaskHelper.formatPhoneToMask("+\(phoneNum)")
    }
    //
    static func formatPhone(_ phone: String?) -> String {
        guard let phone = phone else { return "" }
        return phone.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "")
    }
    static func isValidPhone(_ phone: String?) -> Bool {
        guard let phone = phone else { return false }
        let phoneF = formatPhone(phone)
        return (phoneF.count == 11)
    }
}

/*
 primaryFormat: "{+}[00] [000] [000] [00] [00]"
 primaryFormat: "{+38 0}[00] [000] [00] [00]"
 let maskStr = "+7 ([000]) [000] [00] [00]"
*/
