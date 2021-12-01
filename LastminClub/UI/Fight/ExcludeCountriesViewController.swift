//
//  ExcludeCountriesViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 17.04.2021.
//

import UIKit

class ExcludeCountriesViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    // MARK: - Variables
    var exList: [String] = ["UK", "Ukraine", "Russia"]
    
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
        //tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
    }

    // MARK: - Navigation
    private func goToFlightCountryListVC() {
        let vc: FlightCountryListViewController = UIStoryboard.controller(.flight)
        self.pushVC(vc)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ExcludeCountriesViewController: UITableViewDataSource, UITableViewDelegate {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCellNib(HeaderTableViewCell.className)
        tableView.registerCellNib(SelectTableViewCell.className)
        tableView.registerCellNib(PushTableViewCell.className)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return exList.count + 1
        case 1: return 2
        default: return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 0:
            switch row {
            case 0:
                let cell: HeaderTableViewCell = tableView.getCell()
                cell.item = "Do not fly via those countries"
                cell.configureCell()
                return cell
            default:
                let cell: SelectTableViewCell = tableView.getCell()
                cell.item = exList[row - 1]
                cell.isSelect = true
                cell.configureCell()
                return cell
            }
        case 1:
            switch row {
            case 0:
                let cell: HeaderTableViewCell = tableView.getCell()
                cell.item = ""
                cell.configureCell()
                return cell
            default:
                let cell: PushTableViewCell = tableView.getCell()
                cell.item = "More"
                cell.configureCell()
                cell.didPush = { self.goToFlightCountryListVC() }
                return cell
            }
        default: return UITableViewCell()
        }
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
