//
//  FlightCountryListViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 17.04.2021.
//

import UIKit

class FlightCountryListViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    // MARK: - Variables
    var list: [String] = ["Laos", "Latvia", "Lebanon", "Turkey", "Tanzanya"]
    var sections = [Section]()
    
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
extension FlightCountryListViewController: UITableViewDataSource, UITableViewDelegate {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCellNib(LetterTableViewCell.className)
        tableView.registerCellNib(FlightCountryTableViewCell.className)
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
        let cell: FlightCountryTableViewCell = tableView.getCell()
        cell.item = sectionData.names[row]
        cell.row = row
        cell.count = sectionData.names.count
        cell.configureCell()
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

/*
 France – 82.6 million visitors
 The United States – 75.6 million visitors
 Spain – 75.6 million visitors
 China – 59.3 million visitors
 Italy – 52.4 million visitors
 United Kingdom – 35.8 million visitors
 Germany – 35.6 million visitors
 Mexico – 35.0 million visitors
 Thailand – 32.6 million visitors
 Turkey – 30 million visitors
 Austria – 28.1 million visitors
 Malaysia – 26.8 million visitors
 Hong Kong – 26.6 million visitors
 14. Greece – 24.8 million visitors
 15. Russia – 24.6 million visitors
 16. Japan – 24.0 million visitors
 17. Canada – 20.0 million visitors
 18. Saudi Arabia – 18.0 million visitors
 19. Poland – 17.5 million visitors
 20. South Korea – 17.2 million visitors
 21. Netherlands – 15.8 million visitors
 22. Macao – 15.7 million visitors
 23. Hungary – 15.3 million visitors
 24. United Arab Emirates – 14.9 million visitors
 25. India – 14.6 million visitors
 26. Croatia – 13.8 million visitors
 27. Ukraine – 13.3 million visitors
 28. Singapore – 12.9 million visitors
 29. Indonesia – 12.0 million visitors
 30. Czech Republic – 11.9 million visitors
 
 
 */
/*
 
 */
