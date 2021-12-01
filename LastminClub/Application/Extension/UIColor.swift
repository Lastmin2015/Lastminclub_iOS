//
//  UIColor.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.03.2021.
//

import UIKit

// MARK: - UIKit
func hexToUIColor(_ hex: String, _ alpha: CGFloat = 1.0) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) { cString.remove(at: cString.startIndex) }
    if ((cString.count) != 6) { return UIColor.gray }
    var rgbValue: UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(alpha)
    )
}

func hexToCGColor(_ hex: String, _ alpha: CGFloat = 1.0) -> CGColor {
    return hexToUIColor(hex, alpha).cgColor
}
