//
//  FavoriteHotelListViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 21.04.2021.
//

import UIKit

class FavoriteHotelListViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    // MARK: - IBAction
    //@IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    // MARK: - Variables
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
        list = Tour.demoList()//.filter { appService.favHotelIdList.contains($0?.hotel.id) }
        tableView.reloadData()
        //fetchData()
        //load_newTokenList()
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
        //tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
    }

    // MARK: - Navigation
    private func goToHotelVC(_ item: Tour) {
        let vc: HotelViewController = UIStoryboard.controller(.search)
        vc.item = item
        self.pushVC(vc)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FavoriteHotelListViewController: UITableViewDataSource, UITableViewDelegate {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCellNib(HotelTableViewCell.className)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = list[indexPath.row]
        let cell: HotelTableViewCell = tableView.getCell()
        cell.item = item
        cell.isFavoriteView = true
        cell.didSelect = { self.goToHotelVC(item) }
        cell.configureCell()
        return cell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: DELETE
extension FavoriteHotelListViewController {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //let task = list[indexPath.row]
            //fileService.bookmark_delete("\(task.id)")
            //list = list.filter { $0.id != task.id }
            //tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
}
