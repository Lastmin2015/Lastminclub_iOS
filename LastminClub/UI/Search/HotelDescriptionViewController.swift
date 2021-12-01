//
//  HotelDescriptionViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 24.04.2021.
//

import UIKit

class HotelDescriptionViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var infoMainLabel: UILabel!
    @IBOutlet weak var infoDetailsLabel: UILabel!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    // MARK: - Variables
    var item: Hotel!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        infoMainLabel.text = item.info_main
        infoDetailsLabel.text = item.info_details
    }

    // MARK: - SetupUI
    private func setupUI() {
    }
}
