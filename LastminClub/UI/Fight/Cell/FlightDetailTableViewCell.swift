//
//  FlightDetailTableViewCell.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 27.04.2021.
//

import UIKit

class FlightDetailTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityFromLabel: UILabel!
    @IBOutlet weak var cityToLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeFromLabel: UILabel!
    @IBOutlet weak var timeToLabel: UILabel!
    @IBOutlet weak var cityCodeFromLabel: UILabel!
    @IBOutlet weak var cityCodeToLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var countStopsLabel: UILabel!
    @IBOutlet weak var count2StackView: UIStackView!
    @IBOutlet weak var count3StackView: UIStackView!
    @IBOutlet weak var countNStackView: UIStackView!
    @IBOutlet weak var diffTimeLabel: UILabel!
    // MARK: - Variables
    var item: Flight!
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
        dateLabel.text = item.dateDeparture.toStringZ0(dF6_EEEE_ddMMMMyyyy)
        cityFromLabel.text = item.cityFrom.name
        cityToLabel.text = item.cityTo.name
        priceLabel.text = item.price.toMoney()
        timeFromLabel.text = item.dateDeparture.toStringZ0(dF7_Hmm)
        timeToLabel.text = item.dateArrival.toStringZ0(dF7_Hmm)
        cityCodeFromLabel.text = item.cityFrom.id
        cityCodeToLabel.text = item.cityTo.id
        durationLabel.text = Date.secondsToTimeParts(item.duration)
        let countStops = item.countStops
        countStopsLabel.text = (countStops == 0) ? "Direct" : "Stops: \(countStops)"
        countStopsLabel.textColor = hexToUIColor((countStops==0) ? "8A8A8D" : "009D97")
        countNStackView.isHidden = !(countStops > 3)
        count2StackView.isHidden = (countStops < 2)
        count3StackView.isHidden = !(countStops == 3)
        diffTimeLabel.isHidden = true
    }
}
