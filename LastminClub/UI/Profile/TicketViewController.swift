//
//  TicketViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 01.04.2021.
//

import UIKit

class TicketViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var leadingRegViewConstraint: NSLayoutConstraint!
    //@IBOutlet var actionButtonList: [UIButton]!
    // MARK: - IBAction
    //@IBAction func backButtonPressed(_ sender: UIButton) { popVC(false) }
    @IBAction func backButtonPressed(_ sender: UIButton) { self.dismiss(animated: false, completion: nil) }
    @IBAction func shareButtonPressed(_ sender: UIButton) {  }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {  }
    // MARK: - Variables
    var item: String!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
    private func goToVC() {
        //let vc: PswViewController = UIStoryboard.controller(.auth)
        //vc.email = Validator().email_clear(emailTextField.text)
        //self.pushVC(vc)
    }
}
