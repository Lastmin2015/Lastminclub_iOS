//
//  CountryListViewController.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 10.06.2021.
//

import UIKit

struct Section {
    let letter : String
    let names : [String]
}

class CountryListViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    // MARK: - Variables
    var list: [String] = appConst.countryList()
    var sections = [Section]()
    var didSelect: ((String)->Void)?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTapAround()
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
        // group the array to ["N": ["Nancy"], "S": ["Sue", "Sam"], "J": ["John", "James", "Jenna"], "E": ["Eric"]]
        let groupedDictionary = Dictionary(grouping: list, by: {String($0.prefix(1))})
        // get the keys and sort them
        let keys = groupedDictionary.keys.sorted()
        // map the sorted keys to a struct
        sections = keys.map{ Section(letter: $0, names: groupedDictionary[$0]!.sorted()) }
        self.tableView.reloadData()
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
        //tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
    }

    // MARK: - Navigation
    private func goToVC() {
        //let vc: PswViewController = UIStoryboard.controller(.auth)
        //vc.email = Validator().email_clear(emailTextField.text)
        //self.pushVC(vc)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CountryListViewController: UITableViewDataSource, UITableViewDelegate {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCellNib(LetterTableViewCell.className)
        tableView.registerCellNib(CountryTableViewCell.className)
    }
    //https://stackoverflow.com/questions/28087688/alphabetical-sections-in-table-table-view-in-swift
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].names.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let sectionData = sections[indexPath.section]
        let item = sectionData.names[row]
        let cell: CountryTableViewCell = tableView.getCell()
        cell.item = item
        cell.row = row
        cell.count = sectionData.names.count
        cell.configureCell()
        cell.didSelect = { self.didSelect?(item); self.popVC(false) }
        return cell
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections.map{$0.letter}
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].letter
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
