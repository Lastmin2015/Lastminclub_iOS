//
//  CoTravellerTableViewCell.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 06.04.2021.
//

import UIKit

class CoTravellerTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    // MARK: - Variables
    var item: User!
    var typeCell: TypeCell = .open
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
        nameLabel.text = item.fullname
        
        let imageName = (typeCell == .open) ? "arrowR" : "select"
        iconImageView.image = UIImage(named: imageName)
        switch typeCell {
        case .open: iconImageView.isHidden = false
        case .select: iconImageView.isHidden = !isSelect
        }
    }
}
