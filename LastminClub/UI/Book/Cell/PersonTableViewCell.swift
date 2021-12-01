//
//  PersonTableViewCell.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.04.2021.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var personLabel: UILabel!
    // MARK: - Variables
    var headerText: String = ""
    var item: User?
    var didSelect: (()->Void)?
    var didAddFromList: (()->Void)?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTapGesture(self.contentView)
        setupTapGestureRecognizer()
    }
    override func handleTap(_ gestureRecognizer: UITapGestureRecognizer) { didSelect?() }
    
    // MARK: - SetupCell
    func configureCell() {
        headerLabel.text = headerText
        addLabel.isHidden = (item != nil)
        personLabel.text = item?.fullname ?? "Add"
    }
}

// MARK: - UITapGestureRecognizer
extension PersonTableViewCell {
    private func setupTapGestureRecognizer() {
        addLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap_addFromList)))
        addLabel.isUserInteractionEnabled = true
    }
    @objc func tap_addFromList(_ gestureRecognizer: UITapGestureRecognizer) {
        didAddFromList?()
    }
}
