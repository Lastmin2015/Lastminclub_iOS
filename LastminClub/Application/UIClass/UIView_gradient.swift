//
//  UIView_gradient.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 27.04.2021.
//

import UIKit

class UIView_gradient: UIView {
    // MARK: Public Properties
    @IBInspectable public var color0: UIColor = hexToUIColor("085ACD")
    @IBInspectable public var color1: UIColor = hexToUIColor("08B9F1")
    // MARK: Private Properties
    override public class var layerClass: Swift.AnyClass { return CAGradientLayer.self }
    
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
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.colors = [color0.cgColor, color1.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    }
    
    // MARK: - PublicMethods
//    public func setData(_ hex0: String, _ hex1: String) {
//        color0 = hexToUIColor(hex0)
//        color1 = hexToUIColor(hex1)
//        setupLayers()
//    }
}
