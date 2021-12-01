//
//  AppleEmailViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 31.03.2021.
//

import UIKit

class AppleEmailViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    @IBAction func nextButtonPressed(_ sender: UIButton) { () }
    // MARK: - Variables
    var email: String = ""
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
    }

    // MARK: - Navigation
//    private func goToPswVC() {
//        let vc: PswViewController = UIStoryboard.controller(.auth)
//        vc.email = Validator().email_clear(emailTextField.text)
//        self.pushVC(vc)
//    }
//    private func goToCreatePswVC() {
//        let vc: CreatePswViewController = UIStoryboard.controller(.auth)
//        vc.email = Validator().email_clear(emailTextField.text)
//        self.pushVC(vc)
//    }
}
