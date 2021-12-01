//
//  UserOrderDetailsViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 01.04.2021.
//

import UIKit

class UserOrderDetailsViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var refLabel: UILabel!
    @IBOutlet weak var ticket1Label: UILabel!
    @IBOutlet weak var ticket2Label: UILabel!
    @IBOutlet var menuViewList: [UIView]!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    // MARK: - Variables
    var item: Tour!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGestureRecognizer()
        setupFormData()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Screen.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Screen.lockOrientation(.all)
    }
    
    // MARK: - setupFormData
    private func setupFormData() {
        //nameLabel.text =
        //addressLabel.text =
        //refLabel.text = "Order Ref # \()"
        ticket1Label.text = "RIX - AYT 21.05.21 Tickets"
        ticket1Label.text = "AYT - RIX 28.05.21 Tickets"
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
    }

    // MARK: - Navigation
    private func goToTicketVC(_ item: String) {
        let vc: TicketViewController = UIStoryboard.controller(.profile)
        vc.item = item
        self.present(vc, animated: false, completion: nil)
        //self.pushVC(vc, false)
    }
}

// MARK: - setupTapGestureRecognizer_
extension UserOrderDetailsViewController {
    private func setupTapGestureRecognizer() {
        menuViewList.forEach { $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap_menuView))) }
    }
    @objc private func tap_menuView(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let tag = gestureRecognizer.view?.tag else { return }
        switch tag {
        case 1: ()
        case 4: goToTicketVC("ticket")
        case 5: goToTicketVC("ticket")
        default: ()
        }
    }
}
