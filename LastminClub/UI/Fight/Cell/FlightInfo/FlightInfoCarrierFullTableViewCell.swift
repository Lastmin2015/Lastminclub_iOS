//
//  FlightInfoCarrierFullTableViewCell.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 23.06.2021.
//

import UIKit

class FlightInfoCarrierFullTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var airlineLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var flightNoLabel: UILabel!
    // MARK: - Variables
    var item: RouteFlight!
    var didSelect: (()->Void)?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTapGesture(self.contentView)
    }
    override func handleTap(_ gestureRecognizer: UITapGestureRecognizer) { didSelect?() }
    
    // MARK: - SetupCell
    func configureCell() {
        timeLabel.text = Date.secondsToTimeParts(item.duration)
        airlineLabel.text = item.airline
        categoryLabel.text = item.category
        flightNoLabel.text = item.flightNo
    }
}
