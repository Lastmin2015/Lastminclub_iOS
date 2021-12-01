//
//  FlightSearchOptionsViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 13.04.2021.
//

import UIKit

class FlightSearchOptionsViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var isAddNearbyAirportsSwitch: UISwitch!
    @IBOutlet weak var countBaggageCheckedView: UIView_count!
    @IBOutlet weak var countBaggageCabinView: UIView_count!
    @IBOutlet weak var routeMaximumDurationView: UIView_count!
    @IBOutlet weak var routeMaximumStopView: UIView_count!
    @IBOutlet weak var excludeCountriesLabel: UILabel!
    
    @IBOutlet var typeSearchViewList: [UIView]!
    @IBOutlet var typeSearchImageViewList: [UIImageView]!
    @IBOutlet var menuViewList: [UIView]!
    // MARK: - IBAction
    @IBAction func saveOFSButtonPressed(_ sender: UIButton) { saveOFS() }
    @IBAction func changeIsAddNearbyAirportsValueSwitch(_ sender: UISwitch) { changeIsAddNearbyAirportsValue() }
    @IBAction func searchButtonPressed(_ sender: UIButton) { search() }
    // MARK: - Variables
    var dataOFS: OptionsFlightSearch = OptionsFlightSearch()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTapAround()
        setupTapGestureRecognizer()
        setup_countView()
        if let item = OptionsFlightSearch.loadLastLocally() { dataOFS = item }
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
        isAddNearbyAirportsSwitch.setOn(dataOFS.isAddNearbyAirports, animated: false)
        countBaggageCheckedView.setData(minCount: 0, maxCount: 99, count: dataOFS.countBaggageChecked)
        countBaggageCabinView.setData(minCount: 0, maxCount: 99, count: dataOFS.countBaggageCabin)
        routeMaximumDurationView.setData(minCount: 0, maxCount: 99, count: dataOFS.routeMaximumDuration)
        routeMaximumStopView.setData(minCount: 0, maxCount: 99, count: dataOFS.routeMaximumStop)
        excludeCountriesLabel.text = dataOFS.excludeCountriesStr()
    }
    
    // MARK: - Actions
    private func saveOFS() {
        dataOFS.saveLastLocally()
        goToSearchHotelListVC()
    }
    private func changeIsAddNearbyAirportsValue() {
        dataOFS.isAddNearbyAirports = isAddNearbyAirportsSwitch.isOn
        setupFormData()
    }
    private func search() {
        searchFlights()
        //goToSearchHotelListVC()
    }

    // MARK: - SetupUI
    private func setupUI() {
        setupUI_typeSearchView()
    }
    
    private func setup_countView() {
        countBaggageCheckedView.didUpdateCount = { (newCount) in
            self.dataOFS.countBaggageChecked = newCount
        }
        countBaggageCabinView.didUpdateCount = { (newCount) in
            self.dataOFS.countBaggageCabin = newCount
        }
        routeMaximumDurationView.didUpdateCount = { (newCount) in
            self.dataOFS.routeMaximumDuration = newCount
        }
        routeMaximumStopView.didUpdateCount = { (newCount) in
            self.dataOFS.routeMaximumStop = newCount
        }
    }

    // MARK: - Navigation
    private func goToSearchHotelListVC() {
        self.tabBarController?.selectedIndex = 0
        let vc: SearchHotelListViewController = UIStoryboard.controller(.search)
        guard let navVC = self.tabBarController?.viewControllers?.first as? UINavigationController else { return }
        navVC.popToRootViewController(animated: false)
        navVC.pushViewController(vc, animated: false)
    }
    private func goToFlightsDetailsVC(_ list: [Flight]) {
        let vc: FlightsDetailsViewController = UIStoryboard.controller(.flight)
        vc.list = list
        self.pushVC(vc)
    }
}

// MARK: - setupTapGestureRecognizer_
extension FlightSearchOptionsViewController {
    private func setupTapGestureRecognizer() {
        typeSearchViewList.forEach { $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap_typeSearchView))) }
        menuViewList.forEach { $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap_menuView))) }
    }
    @objc private func tap_typeSearchView(_ gestureRecognizer: UITapGestureRecognizer) {
        dismissKeyboard()
        guard let tag = gestureRecognizer.view?.tag else { return }
        dataOFS.typeSearch = tag
        setupUI_typeSearchView()
    }
    private func setupUI_typeSearchView() {
        typeSearchImageViewList.forEach { $0.isHidden = ($0.tag != dataOFS.typeSearch) }
    }
    @objc private func tap_menuView(_ gestureRecognizer: UITapGestureRecognizer) {
        dismissKeyboard()
        guard let tag = gestureRecognizer.view?.tag else { return }
        switch tag {
        case 1:
            let vc: ExcludeCountriesViewController = UIStoryboard.controller(.flight)
            self.pushVC(vc)
        default: ()
        }
    }
}

// MARK: - API
extension FlightSearchOptionsViewController {
    private func searchFlights() {
        let data: DataSearchFlight = DataSearchFlight()
        data.dateFrom = "01/08/2021".toDate(df1_ddMMyyyy)
        data.dateTo = "10/08/2021".toDate(df1_ddMMyyyy)
//        data.cityFrom = City(id: "FRA", name: "Frankfurt")
//        data.cityTo = City(id: "PRG", name: "Prague")
        data.cityFrom = City(id: "VKO", name: "Moscow-Vnukovo")
        data.cityTo = City(id: "GZP", name: "Gazipasha")
        let pathFilter = data.pathFilter()
        
        self.hudShow()
        API.searchFlight(pathFilter) { [weak self] (result) in
            guard let sSelf = self else { return }
            sSelf.hudHide()
            
            switch result {
            case .failure(let error): error.run(sSelf)
            case .success(let list):
                sSelf.goToFlightsDetailsVC(list)
                print("searchFlights: \(list.count)")
            }
        }
        
//        self.hudShow()
//        RouteAPI.userPhoto_upload(image, progressHandler: { (progress) in
//            print("progress: \(progress)")
//        }) { (result) in
//            self.hudHide()
//            switch result {
//            case .failure(let error): error.run(self)
//            case .success:
//                appService.userPhoto = image
//                self.avaImageView.image = image
//                self.setupUI_avaEditButton()
//            }
//        }
    }
}
