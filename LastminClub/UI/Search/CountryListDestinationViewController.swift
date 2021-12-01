//
//  CountryListDestinationViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 09.04.2021.
//

import UIKit

class CountryListDestinationViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    // MARK: - Variables
    var list: [String] = appService.countryList.map { $0.name }
    //["Turkey", "Greece", "Egypt", "Spain"]
    var didSelect: ((String?)->Void)?
    var item: String?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: - Actions

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

// MARK: - PickerView
extension CountryListDestinationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
