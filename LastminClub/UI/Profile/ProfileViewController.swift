//
//  ProfileViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 01.04.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var avaImageView: UIImageView!
    @IBOutlet weak var avaEditButton: UIButton!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet var menuViewList: [UIView]!
    // MARK: - IBAction
    @IBAction func avaEditButtonPressed(_ sender: UIButton) { goToChoosePhoto() }
    // MARK: - Variables
    var imagePicker: ImagePicker!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGestureRecognizer()
        setup_imagePicker()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Screen.lockOrientation(.portrait, andRotateTo: .portrait)
        //
        setupFormData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Screen.lockOrientation(.all)
    }
    
    // MARK: - setupFormData
    private func setupFormData() {
        guard let user = appService.user else { return }
        fullnameLabel.text = user.fullname
        avaImageView.image = (appService.userPhoto == nil) ? UIImage(named: "ava_default") : appService.userPhoto
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
        avaImageView.round_iv()
        setupUI_avaEditButton()
    }
    private func setupUI_avaEditButton() {
        let imageName = (appService.userPhoto == nil) ? "ava_add" : "ava_edit"
        avaEditButton.setImage(UIImage(named: imageName), for: .normal)
    }

    // MARK: - Navigation
}

// MARK: - setupTapGestureRecognizer
extension ProfileViewController {
    private func setupTapGestureRecognizer() {
        menuViewList.forEach { $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap_menuView))) }
    }
    @objc private func tap_menuView(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let tag = gestureRecognizer.view?.tag else { return }
        switch tag {
        case 1:
            let vc: UserOrderListViewController = UIStoryboard.controller(.profile)
            self.pushVC(vc)
        case 2:
            guard let user = appService.user else { return }
            let vc: UserDataViewController = UIStoryboard.controller(.profile)
            vc.item = user
            self.pushVC(vc)
        case 3:
            let vc: CoTravellerListViewController = UIStoryboard.controller(.profile)
            self.pushVC(vc)
        case 4:
            let vc: PswChangeViewController = UIStoryboard.controller(.profile)
            self.pushVC(vc)
        case 5:
            User.signOut()
            let vc: WelcomeViewController = UIStoryboard.controller(.main)
            self.present(vc)
        default: ()
        }
    }
}

// MARK: - ImagePickerDelegate
extension ProfileViewController: ImagePickerDelegate {
    private func setup_imagePicker() {
        imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    private func goToChoosePhoto() { imagePicker.present(from: avaImageView) }
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        userPhoto_upload(image)
    }
}

// MARK: - API
extension ProfileViewController {
    private func userPhoto_upload(_ image: UIImage?) {
        guard let image = image else { return }
        
        self.hudShow()
        RouteAPI.userPhoto_upload(image, progressHandler: { (progress) in
            print("progress: \(progress)")
        }) { (result) in
            self.hudHide()
            switch result {
            case .failure(let error): error.run(self)
            case .success:
                appService.userPhoto = image
                self.avaImageView.image = image
                self.setupUI_avaEditButton()
            }
        }
    }
}
