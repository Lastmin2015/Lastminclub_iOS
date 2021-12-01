//
//  CountryListGeoViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 09.04.2021.
//

import UIKit

class CountryListWithGeoViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet var menuViewList: [UIView]!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    // MARK: - Variables
    var list: [String] = appService.cityList.map { $0.name }
    //["Riga", "Helsinki", "Berlin", "Vilniius"]
    var didSelect: ((String?)->Void)?
    var item: String?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGestureRecognizer()
        setupPickerView()
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
        if let item = item,
           let row = list.firstIndex(where: { $0.lowercased() == item.lowercased() }) {
            pickerView.selectRow(row, inComponent: 0, animated: false)
        } else { item = list.first! }
        dataLabel.text = item
        didSelect?(item)
    }

    // MARK: - SetupUI
    private func setupUI() {
    }

    // MARK: - Navigation
    private func goToVC() {
        //let vc: PswViewController = UIStoryboard.controller(.auth)
        //vc.email = Validator().email_clear(emailTextField.text)
        //self.pushVC(vc)
    }
}

// MARK: - setupTapGestureRecognizer_
extension CountryListWithGeoViewController {
    private func setupTapGestureRecognizer() {
        menuViewList.forEach { $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap_menuView))) }
    }
    @objc private func tap_menuView(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let tag = gestureRecognizer.view?.tag else { return }
        switch tag {
        case 1: showUserCountry()
        default: ()
        }
    }
    //
    private func showUserCountry() {
        guard GeoCheck(self).isReadyGeo() else { return }
        geoService.getCurrentLocation { (geo) in
            print("geo: \(geo.info())")
            MapKitHelper.geocoder(geo) { (result) in
                switch result {
                case .failure(let error): error.run(self)
                case .success(let country): print(country)
                }
            }
        }
    }
}

// MARK: - PickerView
extension CountryListWithGeoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    private func setupPickerView() {
        pickerView.delegate = self
    }
    // UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        item = list[row]
        dataLabel.text = item
        didSelect?(item)
    }
}
