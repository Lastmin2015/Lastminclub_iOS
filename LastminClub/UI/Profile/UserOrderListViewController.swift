//
//  UserOrderListViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 01.04.2021.
//

import UIKit

class UserOrderListViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var leadingRegViewConstraint: NSLayoutConstraint!
    //@IBOutlet var actionButtonList: [UIButton]!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    @IBAction func micButtonPressed(_ sender: UIButton) { () }
    // MARK: - Variables
    var list: [Tour] = []//Tour.demo2()]
    var resultList: [Tour] = []//Tour.demo2()]
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTapAround()
        setupTextField()
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
    private func search() {
        
    }

    // MARK: - SetupUI
    private func setupUI() {
    }

    // MARK: - Navigation
    private func goToUserOrderDetailsVC(_ item: Tour) {
        let vc: UserOrderDetailsViewController = UIStoryboard.controller(.profile)
        vc.item = item
        self.pushVC(vc)
    }
}

// MARK: - UITextFieldDelegate
extension UserOrderListViewController: UITextFieldDelegate {
    private func setupTextField() {
        searchTextField.delegate = self
        searchTextField.placeholderColor(hexToUIColor("7B7B90"))
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case searchTextField: dismissKeyboard(); search()
        default: ()
        }
        return true
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension UserOrderListViewController: UITableViewDataSource, UITableViewDelegate {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCellNib(HotelTableViewCell.className)
    }
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = resultList[indexPath.row]
        let cell: HotelTableViewCell = tableView.getCell()
        cell.item = item
        cell.didSelect = { self.goToUserOrderDetailsVC(item) }
        cell.configureCell()
        return cell
    }
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
