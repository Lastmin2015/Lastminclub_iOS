//
//  PushTableViewCell.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 17.04.2021.
//

import UIKit

class PushTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var itemLabel: UILabel!
    // MARK: - Variables
    var item: String!
    var didPush: (()->Void)?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTapGesture(self.contentView)
    }
    override func handleTap(_ gestureRecognizer: UITapGestureRecognizer) { didPush?() }
    
    // MARK: - SetupCell
    func configureCell() {
        itemLabel.text = item
    }
}
