//
//  FlightInfoViewController.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 22.06.2021.
//

import UIKit

class FlightInfoViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var cityFromLabel: UILabel!
    @IBOutlet weak var cityToLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    // MARK: - Variables
    var item: Flight!
    var list: [RouteFlight] = []
    var openDict: [Int: Bool] = [:]
    
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
        cityFromLabel.text = item.cityFrom.name
        cityToLabel.text = item.cityTo.name
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
    }

    // MARK: - Navigation
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FlightInfoViewController: UITableViewDataSource, UITableViewDelegate {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        //tableView.register(HeaderViewTV.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        tableView.registerCellNib(FlightInfoTimeAirportTableViewCell.className)
        tableView.registerCellNib(FlightInfoCarrierTableViewCell.className)
        tableView.registerCellNib(FlightInfoConnectionTableViewCell.className)
        tableView.registerCellNib(FlightInfoCarrierFullTableViewCell.className)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = list[section]
        return 3 + ((item.timeConnection == nil) ? 0 : 1)
    }
    // HeaderInSection
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
//                       "sectionHeader") as! HeaderViewTV
//        view.title.text = item.dateDeparture.toStringZ0(dF6_EEEE_ddMMMMyyyy)
//        return view
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        let item = list[section]
        
        switch row {
        case 0:
            let cell: FlightInfoTimeAirportTableViewCell = tableView.getCell()
            cell.timeLabel.text = item.dateDeparture.toStringZ0(dF7_Hmm)
            cell.cityLabel.text = item.cityFrom.name
            cell.airportLabel.text = "no API: airport"//item.cityFrom.name
            return cell
        case 1:
            switch (openDict[section] ?? false) {
            case false:
                let cell: FlightInfoCarrierTableViewCell = tableView.getCell()
                cell.item = item
                cell.configureCell()
                cell.didSelect = { self.didSelectCell_isOpen(indexPath) }
                return cell
            case true:
                let cell: FlightInfoCarrierFullTableViewCell = tableView.getCell()
                cell.item = item
                cell.configureCell()
                cell.didSelect = { self.didSelectCell_isOpen(indexPath) }
                return cell
            }
        case 2:
            let cell: FlightInfoTimeAirportTableViewCell = tableView.getCell()
            cell.timeLabel.text = item.dateArrival.toStringZ0(dF7_Hmm)
            cell.cityLabel.text = item.cityTo.name
            cell.airportLabel.text = "no API: airport"//item.cityTo.name
            return cell
        case 3:
            let cell: FlightInfoConnectionTableViewCell = tableView.getCell()
            cell.item = item
            cell.configureCell()
            return cell
        default: return UITableViewCell()
        }
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    //
    // DidSelect
    private func didSelectCell_isOpen(_ indexPath: IndexPath) {
        let section = indexPath.section
        openDict[section] = !(openDict[section] ?? false)
        //DispatchQueue.main.async { self.tableView.reloadRows(at: [indexPath], with: .automatic) }
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
}
