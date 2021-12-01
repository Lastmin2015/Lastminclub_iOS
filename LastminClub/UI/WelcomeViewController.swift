//
//  WelcomeViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.03.2021.
//

import UIKit

class WelcomeViewController: UIViewController {
    // MARK: - IBOutlet
    //@IBOutlet weak var lineView: UIView!
    // MARK: - IBAction
    // MARK: - Variables
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //KingfisherHelper.clearCache()
        setupUI()
        setupAnimate()
        setupAppData_Shop()
        // MARK - test
        //goToAuth()
        //goToAddressVC()
        //goToSearch()
        //goToBook()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Screen.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Screen.lockOrientation(.all)
    }
    
    // MARK: - SetupAppData
    private func setupAppData_Shop() {
        appService.load_AppData_Locally()
        //delay(1) { self.goToApp() }
        //goToBook()
        
        self.hudShow()
        appService.setup_AppData_Shop { [weak self] (error) in
            guard let sSelf = self else { return }
            sSelf.hudHide()
            if let error = error { error.run(sSelf); return }
            if appService.token_isExist() { sSelf.setupAppData_User_goToApp() }
            else { sSelf.goToApp() }
        }
    }
    private func setupAppData_User_goToApp() {
        self.hudShow()
        API.load_Data_User { [weak self] (error) in
            guard let sSelf = self else { return }
            sSelf.hudHide()
            if let error = error {
                print(error.text)
                User.signOut()
                sSelf.goToApp()
                return
            }
            
            //QW=сделать проверку на живучесть токена
//            if let error = error {
//                if error.text == APIError.refreshToken.text || error.text == APIError.invalidAuth.text { sSelf.goToAuth(); return }
//                else { error.run(sSelf); return }
//            }
            sSelf.goToApp()
        }
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
    }
    private func setupAnimate() {
//        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .curveEaseIn], animations: {
//            self.lineView.transform = CGAffineTransform(translationX: (260 + 120), y: 0)
//        }, completion: nil)
    }

    // MARK: - Navigation
    private func goToApp() {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
        if !User.isAuth() { vc.selectedIndex = 4 }
        DispatchQueue.main.async { self.present(vc) }
    }
}

// MARK: - Test
extension WelcomeViewController {
    private func goToTest() {
        //OrderReviewViewController
        //let vc: AuthViewController = UIStoryboard.controller(.auth)
        //DispatchQueue.main.async { self.present(vc) }
    }
    private func goToAuth() {
        //OrderReviewViewController
        let vc: CreatePswViewController = UIStoryboard.controller(.auth)
        vc.email = "as@as.ru"
        DispatchQueue.main.async { self.present(vc) }
    }
    private func goToSearch() {
        // DurationViewController HotelViewController
        let vc: SearchHotelListViewController = UIStoryboard.controller(.search)
        DispatchQueue.main.async { self.present(vc) }
    }
    private func goToBook() {
        // OrderViewController BankcardViewController
        let vc: SuccessPayViewController = UIStoryboard.controller(.book)
        //vc.tour = Tour.demo1()
        //vc.item = Bankcard()
        DispatchQueue.main.async { self.present(vc) }
    }
}
