//
//  FlightsDetailsViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 27.04.2021.
//

import UIKit

class FlightsDetailsViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    // MARK: - Variables
    var list: [Flight] = []
    
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
    private func goToFlightInfoVC(_ item: Flight) {
        let vc: FlightInfoViewController = UIStoryboard.controller(.flight)
        vc.item = item
        vc.list = item.routeList
        self.pushVC(vc)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FlightsDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(HeaderViewTV.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        tableView.registerCellNib(FlightDetailTableViewCell.className)
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
//        switch section {
//        case 0: return 1
//        case 1: return tour.countAdult
//        case 2: return tour.countChild
//        case 3: return 1
//        default: return 0
//        }
    }
    // HeaderInSection
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                       "sectionHeader") as! HeaderViewTV
        view.title.text = "2 Adults, 1 Kid"
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = list[indexPath.item]
        
        let cell: FlightDetailTableViewCell = tableView.getCell()
        cell.item = item
        cell.configureCell()
        cell.didSelect = { self.goToFlightInfoVC(item) }
        return cell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
