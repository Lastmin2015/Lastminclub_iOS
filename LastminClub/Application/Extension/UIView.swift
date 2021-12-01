//
//  UIView.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.03.2021.
//

import UIKit

// MARK: - Decorate
extension UIView {
    func decorateView(_ isActive: Bool = false) {
        let layer = self.layer
        layer.masksToBounds = false
        layer.backgroundColor = isActive ? #colorLiteral(red: 0.9490196078, green: 0.4039215686, blue: 0.5137254902, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        layer.cornerRadius = 6
        layer.borderColor = isActive ? #colorLiteral(red: 0.9098039216, green: 0.007843137255, blue: 0.2588235294, alpha: 1) : #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        layer.borderWidth = 1
        layer.shadowColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 0.5)
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowPath = nil
    }
    func decorateView_RoundBorder(_ radius: CGFloat? = nil, _ hex: String = "FFFFFF", _ borderW: CGFloat = 2) {
        let radius: CGFloat = (radius == nil) ? (self.frame.height / 2) : radius!
        let layer = self.layer
        layer.masksToBounds = false
        layer.cornerRadius = radius
        layer.borderColor = hexToCGColor(hex)
        layer.borderWidth = borderW
    }
    func decorateView_shadow() {
        let layer = self.layer
        layer.masksToBounds = false
        layer.cornerRadius = 13
        layer.applyShadow(blur: 60, x: 0, y: 10, "000000", 0.1)
    }
}

// MARK: - Round Corners
extension UIView {
    func round(_ radius: CGFloat? = nil) {
        guard let radius = radius else { layer.cornerRadius = frame.height / 2; return }
        layer.cornerRadius = radius
    }
    func roundCorners(_ cornerRadius: Double, _ maskedCorners: CACornerMask) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = maskedCorners
            //[.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
}

// MARK: - Support Shadow Layer
extension CALayer {
    func applyShadow(blur: CGFloat, x: CGFloat, y: CGFloat, _ hex: String, _ alpha: CGFloat = 1, _ opacity: Float = 1, _ spread: CGFloat = 0) {
        masksToBounds = false
        shadowColor = hexToCGColor(hex, alpha)
        shadowOpacity = opacity
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 { shadowPath = nil }
        else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
