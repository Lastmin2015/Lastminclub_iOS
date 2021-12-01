//
//  FlightInfoConnectionTableViewCell.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 23.06.2021.
//

import UIKit

class FlightInfoConnectionTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var baggageLabel: UILabel!
    @IBOutlet weak var transferLabel: UILabel!
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
        timeLabel.text = "Flight connection: \(Date.secondsToTimeParts(item.timeConnection ?? 0))"
        baggageLabel.text = "no API: Baggage must be re-checked"
        transferLabel.text = "no API: Self-transfer of baggage at the airport CPH"
        transferLabel.underline()
    }
}
