//
//  TourPhotoTableViewCell.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.04.2021.
//

import UIKit
import Kingfisher

class TourPhotoTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    // MARK: - IBAction
    //@IBAction func deleteButtonPressed(_ sender: UIButton) { didDelete?() }
    // MARK: - Variables
    var item: Tour!
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
        nameLabel.text = item.hotel?.name
        locationLabel.text = item.hotel?.location
        priceLabel.text = item.priceStr()
        dateLabel.text = item.periodStr()
        setupUI_favorite()
        load_photo()
        //
    }
    
    // MARK: - SetupUI
    private func setupUI_favorite() {
        favoriteImageView.image = UIImage(named: "heart\(item.hotel?.isFavorite() ?? false ? "1" : "0")")
    }
}

// MARK: - UITapGestureRecognizer
extension TourPhotoTableViewCell {
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

// MARK: - Load Photo
extension TourPhotoTableViewCell {
    private func load_photo() {
        //photoImageView.load_kf(item.hotel?.pathPhoto) { (_) in }
        //
        guard let path = item.hotel?.pathPhoto, let url = URL(string: path) else { return }
        
        let ivSize = photoImageView.bounds.size
        let processor = CroppingImageProcessor(size: ivSize)
        //ResizingImageProcessor(referenceSize: ivSize, mode: .aspectFit) |>
            
        photoImageView.kf.indicatorType = .activity
        photoImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
}
