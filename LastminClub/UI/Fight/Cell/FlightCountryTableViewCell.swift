//
//  FlightCountryTableViewCell.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 17.04.2021.
//

import UIKit

class FlightCountryTableViewCell: UITableViewCell {
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
        }
    }
}
