//
//  SearchTravellersViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 12.04.2021.
//

import UIKit

class SearchTravellersViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    // MARK: - Variables
    //var childCount: Int = 0
    var countAdult: Int = 0
    var countChild: Int = 0
    var ageChildDict: [Int: Int] = [:]
    var didSelect: ((Int, Int, [Int: Int])->Void)?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTapAround()
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
        tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
    }

    // MARK: - Navigation
    private func goToVC() {
        //let vc: PswViewController = UIStoryboard.controller(.auth)
        //vc.email = Validator().email_clear(emailTextField.text)
        //self.pushVC(vc)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchTravellersViewController: UITableViewDataSource, UITableViewDelegate {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCellNib(SearchTravellerTableViewCell.className)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return countChild
        default: return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let typeCell: TypeSearchTravellerCell!
        let cell: SearchTravellerTableViewCell = tableView.getCell()
        
        switch section {
        case 0:
            switch row {
            case 0:
                typeCell = .adultCount
                cell.value = countAdult
                cell.didUpdateCount = { (newValue) in
                    self.countAdult = newValue
                    self.didSelect?(self.countAdult, self.countChild, self.ageChildDict)
                }
            case 1:
                typeCell = .childCount
                cell.value = countChild
                cell.didUpdateCount = { (newValue) in
                    self.ageChildDict.forEach { (key, value) in
                        if key > newValue { self.ageChildDict[key] = nil }
                    }
                    //
                    self.countChild = newValue
                    self.tableView.reloadSections([1], with: .none)
                    self.didSelect?(self.countAdult, self.countChild, self.ageChildDict)
                }
            default: return UITableViewCell()
            }
        case 1:
            typeCell = .childAge
            cell.value = ageChildDict[row+1] ?? 2
            cell.didUpdateCount = { (newValue) in
                self.ageChildDict[row+1] = newValue
                self.didSelect?(self.countAdult, self.countChild, self.ageChildDict)
            }
        default: return UITableViewCell()
        }
        cell.indexPath = indexPath
        cell.typeCell = typeCell
        cell.configureCell()
        return cell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
