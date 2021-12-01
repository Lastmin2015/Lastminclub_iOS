//
//  HotelOptionTableViewCell.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 24.04.2021.
//

import UIKit

class HotelOptionTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var isSelectImageView: UIImageView!
    // MARK: - Variables
    var item: String!
    var isSelect: Bool = false
    var didSelect: (()->Void)?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTapGesture(self.contentView)
    }
    override func handleTap(_ gestureRecognizer: UITapGestureRecognizer) { didSelect?() }
    
    // MARK: - SetupCell
    func configureCell() {
        nameLabel.text = item
        priceLabel.text = "€1 234"
        //
        isSelectImageView.isHidden = !isSelect
    }
}
