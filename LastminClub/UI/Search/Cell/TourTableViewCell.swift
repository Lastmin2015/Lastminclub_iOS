//
//  TourTableViewCell.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 24.04.2021.
//

import UIKit

class TourTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fDetailsLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    // MARK: - IBAction
    //@IBAction func deleteButtonPressed(_ sender: UIButton) { didDelete?() }
    // MARK: - Variables
    var item: Tour!
    var isFavoriteView: Bool = false
    var didSelect: (()->Void)?
    //var didDelete: (()->Void)?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTapGesture(self.contentView)
        setupTapGestureRecognizer()
    }
    override func handleTap(_ gestureRecognizer: UITapGestureRecognizer) { didSelect?() }
    
    // MARK: - SetupCell
    func configureCell() {
        nameLabel.text = "HEL - ANT"
        fDetailsLabel.text = "2 stops, 10 hours"
        priceLabel.text = item.priceStr()
        dateLabel.text = item.periodStr()
        setupUI_favorite()
        //
        favoriteImageView.isHidden = isFavoriteView
    }
    
    // MARK: - SetupUI
    private func setupUI_favorite() {
        favoriteImageView.image = UIImage(named: "heart\(item.hotel?.isFavorite() ?? false ? "1" : "0")")
    }
}

// MARK: - UITapGestureRecognizer
extension TourTableViewCell {
    private func setupTapGestureRecognizer() {
        favoriteImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap_favoriteImageView)))
        favoriteImageView.isUserInteractionEnabled = true
    }
    @objc func tap_favoriteImageView(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let hotel = item.hotel else { return }

        switch hotel.isFavorite() {
        case true: hotel.favoriteDelete()
        case false: hotel.favoriteAdd()
        //case true: hotel.favoriteDeleteByAPI { (_) in self.setupUI_favorite() }
        //case false: hotel.favoriteAddByAPI { (_) in self.setupUI_favorite() }
        }
        setupUI_favorite()
    }
}
