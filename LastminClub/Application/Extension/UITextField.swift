//
//  UITextField.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.03.2021.
//

import UIKit

// MARK: - Helper
extension UITextField {
    var isEmpty: Bool { return (self.text ?? "").isEmpty }
    var textStr: String { return self.text ?? "" }
}

// MARK: - PlaceholderColor
extension UITextField {
    func placeholderColor(_ color: UIColor) {
        var placeholderText = ""
        if self.placeholder != nil { placeholderText = self.placeholder! }
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
//    func placeholderColorFont(_ color: UIColor, _ font: UIFont?) {
//        guard let font = font else { print("Error: invalid font"); return }
//        let attributes =
//            [
//                NSAttributedString.Key.foregroundColor: color,
//                NSAttributedString.Key.font: font
//            ]// Note the ! UIFont(name: "Roboto-Bold", size: 17)!
//        let placeholderText = (self.placeholder != nil) ? self.placeholder! : ""
//        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
//    }
}

// MARK: - Padding
extension UITextField {
    func setPadding(_ padding: CGFloat) {
        setLeftPadding(padding)
        setRightPadding(padding)
    }
    func setLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

// MARK: - Toolbar
extension UITextField {
    // MARK: Toolbar
    func addInputAccessoryView(title: String = "Готово", target: Any, selector: Selector) {
        let toolbarCGRect = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0)
        let toolBar = UIToolbar(frame: toolbarCGRect)
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .done, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        toolBar.tintColor = hexToUIColor("009d97")
        self.inputAccessoryView = toolBar
    }
    /*
     self.myTextField.addInputAccessoryView(title: "Done", target: self, selector: #selector(tapDone))
     @objc func tapDone() { self.view.endEditing(true) }
     */
    //
    func addInputAccessoryView_cancelDone(target: Any, selectorCancel: Selector, selectorDone: Selector) {
        let toolbarCGRect = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0)
        let toolBar = UIToolbar(frame: toolbarCGRect)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: target, action: selectorCancel)
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: target, action: selectorDone)
        toolBar.setItems([cancelButton, flexible, doneButton], animated: false)
        toolBar.tintColor = hexToUIColor("009d97")
        self.inputAccessoryView = toolBar
    }
}
