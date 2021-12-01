//
//  SearchTourViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 09.04.2021.
//

import UIKit

class SearchTourViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var pointOrigLabel: UILabel!
    @IBOutlet weak var pointDestLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var travellersLabel: UILabel!
    @IBOutlet var menuViewList: [UIView]!
    // MARK: - IBAction
    @IBAction func searchButtonPressed(_ sender: UIButton) { searchTour() }
    // MARK: - Variables
    var dataST: DataSearchTour = DataSearchTour()
    var countAdult: Int? = nil
    var countChild: Int? = nil
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGestureRecognizer()
        if let item = DataSearchTour.loadLastLocally() { dataST = item }
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
        pointOrigLabel.text = dataST.pointOrig
        pointDestLabel.text = dataST.pointDest
        periodLabel.text = dataST.periodStr()
        travellersLabel.text = dataST.travellersStr()
        
        dataST.saveLastLocally()
    }
    
    // MARK: - Actions
//    private func search() {
//        goToSearchHotelListVC()
//    }

    // MARK: - SetupUI
    private func setupUI() {
    }

    // MARK: - Navigation
    private func goToSearchHotelListVC(_ list: [Tour]) {
        let vc: SearchHotelListViewController = UIStoryboard.controller(.search)
        vc.list = list
        self.pushVC(vc)
    }
}

// MARK: - setupTapGestureRecognizer_
extension SearchTourViewController {
    private func setupTapGestureRecognizer() {
        menuViewList.forEach { $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap_menuView))) }
    }
    @objc private func tap_menuView(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let tag = gestureRecognizer.view?.tag else { return }
        switch tag {
        case 1:
            let vc: CountryListWithGeoViewController = UIStoryboard.controller(.search)
            vc.item = dataST.pointOrig
            vc.didSelect = { (item) in
                self.dataST.pointOrig = item
                self.setupFormData()
            }
            self.pushVC(vc)
        case 2:
            let vc: CountryListDestinationViewController = UIStoryboard.controller(.search)
            vc.item = dataST.pointDest
            vc.didSelect = { (item) in
                self.dataST.pointDest = item
                self.setupFormData()
            }
            self.pushVC(vc)
        case 3:
            let vc: DurationViewController = UIStoryboard.controller(.search)
            vc.didSelect = { (item) in
                self.dataST.date0 = item.date0
                self.dataST.date1 = item.date1
                self.setupFormData()
            }
            self.pushVC(vc)
        case 4:
            let vc: SearchTravellersViewController = UIStoryboard.controller(.search)
            vc.countAdult = dataST.countAdult
            vc.countChild = dataST.countChild
            vc.ageChildDict = dataST.ageChildDict
            vc.didSelect = { (countAdult, countChild, ageChildDict) in
                self.countAdult = countAdult
                self.countChild = countChild
                
                self.dataST.countAdult = countAdult
                self.dataST.countChild = countChild
                self.dataST.ageChildDict = ageChildDict
                self.setupFormData()
            }
            self.pushVC(vc)
        default: ()
        }
    }
}

// MARK: API
extension SearchTourViewController {
    // Genre
    private func searchTour() {
        guard let date0 = dataST.date0, let date1 = dataST.date1,
              let pointOrig = dataST.pointOrig, let pointDest = dataST.pointDest
        else { return }
        var dict: JSON = [:]
        dict["origin"] = pointOrig
        dict["destination"] = pointDest
        dict["start_date"] = date0.timeIntervalSince1970
        dict["end_date"] = date1.timeIntervalSince1970
        dict["adults"] = dataST.countAdult
        dict["children"] = dataST.countChild
        dict["with_data"] = true
        dict["locale"] = Language.current.iosId
        
        dict["origin"] = "Tenerife" //QW=test
        dict["destination"] = "İzmir" //QW=test
        dict["start_date"] = 1635706800 //QW=test
        dict["end_date"] = 1638298800 //QW=test
        dict["adults"] = nil
        dict["children"] = nil
        
        self.hudShow()
        API.tourList(dict) { [weak self] (result) in
            guard let sSelf = self else { return }
            sSelf.hudHide()
            switch result {
            case .failure(let error): error.run(sSelf)
            case .success(let list):
                sSelf.goToSearchHotelListVC(list)
                print("tourList: \(list.count)")
            }
        }
    }
}
