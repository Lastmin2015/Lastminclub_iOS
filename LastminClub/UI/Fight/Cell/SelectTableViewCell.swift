//
//  SelectTableViewCell.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 17.04.2021.
//

import UIKit

class SelectTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
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
        selectImageView.isHidden = !isSelect
        itemLabel.text = item
    }
}
