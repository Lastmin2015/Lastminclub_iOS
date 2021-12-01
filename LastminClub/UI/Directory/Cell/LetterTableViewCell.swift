//
//  LetterTableViewCell.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 17.04.2021.
//

import UIKit

class LetterTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var headerLabel: UILabel!
    // MARK: - Variables
    var item: String = ""
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - SetupCell
    func configureCell() {
        headerLabel.text = item
    }
}
