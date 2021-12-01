//
//  SearchHotelListViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 21.04.2021.
//

import UIKit

class SearchHotelListViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    @IBAction func settingsButtonPressed(_ sender: UIButton) { goToSettingsSearchHotelListVC() }
    // MARK: - Variables
    var sizeImage: Int = 22
    var list: [Tour] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
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
        headerLabel.text = "???API???"//Turkey, 01/06/2021"
        //fetchData()
        //load_newTokenList()
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
        //tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
    }

    // MARK: - Navigation
    private func goToSettingsSearchHotelListVC() {
        let vc: SettingsSearchHotelListViewController = UIStoryboard.controller(.search)
        vc.sizeImage = self.sizeImage
        vc.didSelectSize = { (newSize) in
            self.sizeImage = newSize
            self.tableView.reloadData()
        }
        self.pushVC(vc)
    }
    private func goToHotelListVC(_ item: Tour) {
        let vc: HotelViewController = UIStoryboard.controller(.search)
        vc.item = item
        self.pushVC(vc)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchHotelListViewController: UITableViewDataSource, UITableViewDelegate {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCellNib(HotelTableViewCell.className)
        tableView.registerCellNib(HotelBigPhotoTableViewCell.className)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = list[indexPath.row]
        item.hotel?.showAllPath()
        if sizeImage == 22 {
            let cell: HotelTableViewCell = tableView.getCell()
            cell.item = item
            cell.didSelect = { self.goToHotelListVC(item) }
            cell.configureCell()
            return cell
        } else {
            let cell: HotelBigPhotoTableViewCell = tableView.getCell()
            cell.item = item
            cell.didSelect = { self.goToHotelListVC(item) }
            cell.configureCell()
            return cell
        }
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
