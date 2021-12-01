//
//  UIImageView.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 01.04.2021.
//

import UIKit

// MARK: - Round Corners
extension UIImageView {
    func round_iv(_ radius: CGFloat? = nil) {
        layer.masksToBounds = false
        layer.cornerRadius = (radius != nil) ? radius! : frame.height / 2
        clipsToBounds = true
        //self.layer.borderColor = UIColor.black.cgColor
        //self.layer.borderWidth = 1
    }
}
