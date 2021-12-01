//
//  FlightInfoTimeAirportTableViewCell.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 22.06.2021.
//

import UIKit

class FlightInfoTimeAirportTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var airportLabel: UILabel!
    // MARK: - Variables
    //var item: RouteFlight!
    //var didSelect: (()->Void)?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.addTapGesture(self.contentView)
    }
    //override func handleTap(_ gestureRecognizer: UITapGestureRecognizer) { didSelect?() }
}
