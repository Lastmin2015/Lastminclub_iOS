//
//  CoTravellerListViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 06.04.2021.
//

import UIKit

class CoTravellerListViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    @IBAction func addButtonPressed(_ sender: UIButton) { addItem() }
    // MARK: - Variables
    var list: [User] = [User.demo2()]
    var selectIndex: Int? = nil
    var typeCell: TypeCell = .open
    var didSelect: ((User)->Void)?
    
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
        tableView.reloadData()
        //fetchData()
        //load_newTokenList()
    }
    
    // MARK: - Actions
    private func addItem() {
        goToUserDataVC(User())
    }

    // MARK: - SetupUI
    private func setupUI() {
    }

    // MARK: - Navigation
    private func goToUserDataVC(_ item: User) {
        let vc: UserDataViewController = UIStoryboard.controller(.profile)
        vc.item = item
        self.pushVC(vc)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CoTravellerListViewController: UITableViewDataSource, UITableViewDelegate {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCellNib(CoTravellerTableViewCell.className)
    }
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = list[indexPath.row]
        let cell: CoTravellerTableViewCell = tableView.getCell()
        cell.item = item
        cell.typeCell = typeCell
        cell.isSelect = (indexPath.row == selectIndex)
        cell.configureCell()
        cell.didSelect = { self.didSelectCell(indexPath) }
        return cell
    }
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    // didHelpers
    private func didSelectCell(_ indexPath: IndexPath) {
        let item = self.list[indexPath.row]
        switch typeCell {
        case .open: goToUserDataVC(item)
        case .select:
            selectIndex = indexPath.row
            tableView.reloadData()
            delay(0.3) { self.didSelect?(item); self.popVC(false) }
        }
    }
}
// MARK: DELETE
extension CoTravellerListViewController {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.list.remove(at: indexPath.row)
            self.tableView.reloadData()
        }

        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let item = self.list[indexPath.row]
            self.goToUserDataVC(item)
        }
        edit.backgroundColor = hexToUIColor("009d97")

        return [delete, edit]
    }
}
