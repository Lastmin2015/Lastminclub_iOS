//
//  PaymentMethodTableViewCell.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.04.2021.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var bcStackView: UIStackView!
    @IBOutlet weak var bcImageView: UIImageView!
    @IBOutlet weak var bcLabel: UILabel!
    @IBOutlet weak var addEditButton: UIButton!
    @IBOutlet weak var payButton: UIButton!
    // MARK: - IBAction
    @IBAction func payButtonPressed(_ sender: UIButton) { didPay?() }
    // MARK: - Variables
    var headerText: String = ""
    var item: Bankcard?
    var didSelect: (()->Void)?
    var didPay: (()->Void)?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTapGesture(self.contentView)
        addEditButton.decorateView_RoundBorder(8, "8A8A8D", 1)
    }
    override func handleTap(_ gestureRecognizer: UITapGestureRecognizer) { didSelect?() }
    
    // MARK: - SetupCell
    func configureCell() {
        let isExistPay: Bool = (item != nil)
        addEditButton.setTitle(isExistPay ? "Edit" : "Add", for: .normal)
        logoImageView.isHidden = isExistPay
        bcStackView.isHidden = !isExistPay
        //bcImageView.image =
        bcLabel.text = item?.securityNumber()
        payButton.isEnabled = isExistPay
        payButton.backgroundColor = hexToUIColor(isExistPay ? "009d97" : "D1D1D6")
    }
}
