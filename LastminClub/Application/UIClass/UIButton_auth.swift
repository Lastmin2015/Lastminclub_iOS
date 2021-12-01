//
//  UIButton_auth.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.03.2021.
//

import UIKit

class UIButton_auth: UIButton {
    // MARK: - LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let iv = imageView else { return }
        let sizeIm = iv.frame
        let topIm = (bounds.height - sizeIm.height) / 2
        imageEdgeInsets = UIEdgeInsets(top: topIm, left: 16, bottom: topIm, right: bounds.width - (16 + sizeIm.width))
        titleEdgeInsets = UIEdgeInsets(top: 13, left: 16, bottom: 16, right: 16)
    }
}

class UIButton_shadow: UIButton {
    // MARK: Public Properties
    // MARK: Private Properties

    // MARK: - Initializers
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayers()
    }
    
    // MARK: Private Methods
    private func setupLayers() {
        self.round()
        self.layer.applyShadow(blur: 4, x: 0, y: 2, "000000", 0.5)
    }
}
