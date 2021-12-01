//
//  SettingsSearchHotelListViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 21.04.2021.
//

import UIKit

class SettingsSearchHotelListViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet var menuViewList: [UIView]!
    @IBOutlet var menuImageViewList: [UIImageView]!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    //@IBAction func searchButtonPressed(_ sender: UIButton) { search() }
    // MARK: - Variables
    var typeSort: Int = 11
    var sizeImage: Int = 22
    var didSelectSize: ((Int)->Void)?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGestureRecognizer()
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
        //fetchData()
        //load_newTokenList()
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
        setupUI_menuView()
    }

    // MARK: - Navigation
}

// MARK: - setupTapGestureRecognizer_
extension SettingsSearchHotelListViewController {
    private func setupTapGestureRecognizer() {
        menuViewList.forEach { $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap_menuView))) }
    }
    @objc private func tap_menuView(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let tag = gestureRecognizer.view?.tag else { return }
        if (10 <= tag) && (tag <= 19) { typeSort = tag }
        else if (20 <= tag) && (tag <= 29) { sizeImage = tag; didSelectSize?(sizeImage) }
        setupUI_menuView()
    }
    private func setupUI_menuView() {
        menuImageViewList.forEach {
            if (10 <= $0.tag) && ($0.tag <= 19) { $0.isHidden = ($0.tag != typeSort) }
            else if (20 <= $0.tag) && ($0.tag <= 29) { $0.isHidden = ($0.tag != sizeImage) }
        }
    }
}
