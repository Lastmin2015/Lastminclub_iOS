//
//  UILabel.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 23.06.2021.
//

import UIKit

// MARK: - Подчеркивание текста
extension UILabel {
    func underline() {
        guard let textString = text else { return }
        let attributedString = NSMutableAttributedString(string: textString)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }
}
