//
//  CalendarCollectionViewCell.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 09.04.2021.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlet
    //Cell: (46, 46)
    @IBOutlet weak var bgDurView: UIView! // (34, 34)
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var bgDaySelectView: UIView!
    //@IBOutlet weak var daySelectLabel: UILabel!
    // MARK: - Variables
    var calendarDay: CalendarDay!
    var calendarMonth: CalendarMonth!
    var durDays: Int!
    var didSelect: (()->(Void))?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTapGesture(self.contentView)
        bgDaySelectView.round()
    }
    
    // MARK: - Tapped
    override func handleTap(_ gestureRecognizer: UITapGestureRecognizer) { didSelect?() }
    
    // MARK: - Setup UI
    func configureCell() {
        dayLabel.text = "\(calendarDay.date.day())"
        let isSelect = (calendarDay.date == calendarMonth.selDate0)
        DispatchQueue.main.async {
            self.contentView.alpha = self.calendarDay.inMonth ? 1 : 0
            self.bgDurView.isHidden = !self.isDateDur()
            self.bgDaySelectView.isHidden = !isSelect
            //self.dayLabel.textColor = isSelect ? hexToUIColor("FFFFFF") : hexToUIColor("000000")
        }
    }
    
    // MARK: - Helpers
    func isDateDur() -> Bool {
        guard let selDate = calendarMonth.selDate0 else { return false }
        guard calendarDay.date != calendarMonth.selDate0 else { return false }
        let minDate = selDate.addDay(-1 * durDays)
        let maxDate = selDate.addDay(+1 * durDays)
        return ((minDate <= calendarDay.date) && (calendarDay.date <= maxDate))
    }
}
