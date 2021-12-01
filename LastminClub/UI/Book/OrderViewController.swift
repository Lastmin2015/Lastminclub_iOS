//
//  OrderViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.04.2021.
//

import UIKit

class OrderViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    // MARK: - Variables
    var tour: Tour!
    var bankcard: Bankcard? = nil
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
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
    }

    // MARK: - Navigation
    private func goToCoTravellerListVC(_ indexData: Int, _ isAdult: Bool) {
        let vc: CoTravellerListViewController = UIStoryboard.controller(.profile)
        vc.typeCell = .select
        vc.didSelect = { (user) in
            switch isAdult {
            case true: self.tour.adultDict[indexData] = user
            case false: self.tour.childDict[indexData] = user
            }
            self.tableView.reloadData()
        }
        self.pushVC(vc)
    }
    private func goToAddUserDataVC(_ indexData: Int, _ isAdult: Bool) {
        let vc: UserDataViewController = UIStoryboard.controller(.profile)
        vc.item = User()
        self.pushVC(vc)
    }
    private func goToBankcardVC() {
        let vc: BankcardViewController = UIStoryboard.controller(.book)
        vc.item = bankcard ?? Bankcard()
        vc.didSave = { (item) in
            self.bankcard = item
            self.tableView.reloadData()
        }
        self.pushVC(vc)
    }
    private func goToSuccessPayVC() {
        let vc: SuccessPayViewController = UIStoryboard.controller(.book)
        self.pushVC(vc)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension OrderViewController: UITableViewDataSource, UITableViewDelegate {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(HeaderViewTV.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        tableView.registerCellNib(TourPhotoTableViewCell.className)
        tableView.registerCellNib(PersonTableViewCell.className)
        tableView.registerCellNib(PaymentMethodTableViewCell.className)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return tour.countAdult
        case 2: return tour.countChild
        case 3: return 1
        default: return 0
        }
    }
    // HeaderInSection
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                       "sectionHeader") as! HeaderViewTV
        switch section {
        case 1: view.title.text = "Travellers"
        default: return nil
        }
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1: return 38
        default: return 0
        }
    }
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let indexData = row+1
        
        switch section {
        case 0: // Hotel
            let cell: TourPhotoTableViewCell = tableView.getCell()
            cell.item = tour
            cell.configureCell()
            return cell
        case 1: // Adult
            let cell: PersonTableViewCell = tableView.getCell()
            cell.headerText = "ADULT \(indexData)"
            cell.item = tour.adultDict[indexData]
            cell.configureCell()
            cell.didAddFromList = { self.goToCoTravellerListVC(indexData, true) }
            cell.didSelect = { self.goToAddUserDataVC(indexData, true) }
            return cell
        case 2: // Child
            let cell: PersonTableViewCell = tableView.getCell()
            cell.headerText = "KID \(indexData)"
            cell.item = tour.childDict[indexData]
            cell.configureCell()
            cell.didAddFromList = { self.goToCoTravellerListVC(indexData, true) }
            cell.didSelect = { self.goToAddUserDataVC(indexData, false) }
            return cell
        case 3: // BankCard
            let cell: PaymentMethodTableViewCell = tableView.getCell()
            cell.item = bankcard
            cell.configureCell()
            cell.didSelect = { self.goToBankcardVC() }
            cell.didPay = { self.goToSuccessPayVC() }
            return cell
        default: return UITableViewCell()
        }
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
