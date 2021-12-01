//
//  CountryTableViewCell.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 10.06.2021.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    // MARK: - Variables
    var row: Int!
    var count: Int!
    var item: String = ""
    var didSelect: (()->Void)?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTapGesture(self.contentView)
    }
    override func handleTap(_ gestureRecognizer: UITapGestureRecognizer) { didSelect?() }
    
    // MARK: - SetupCell
    func configureCell() {
        headerLabel.text = item
        //
        if count == 1 { bgView.roundCorners(10, [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]) }
        else {
            if row == 0 { bgView.roundCorners(10, [.layerMinXMinYCorner, .layerMaxXMinYCorner]) }
            else if row == (count-1) { bgView.roundCorners(10, [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]) }
            else { bgView.roundCorners(0, [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]) }
        }
    }
}
