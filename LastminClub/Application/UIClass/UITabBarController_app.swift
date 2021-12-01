//
//  UITabBarController_app.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.03.2021.
//

import UIKit

class UITabBarController_app: UITabBarController {
    // MARK: - Variables
    //var item: Product!
    //var didSelectProfile: (()->Void)?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        setupUI()
        setupFormData()
    }
    
    // MARK: - setupFormData
    public func setupFormData(_ selIndex: Int? = nil) {
        //let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        //let vc = storyboard.instantiateViewController(withIdentifier: "navAuth")
        
        //let vc0 = UIStoryboard.nc("navAuthVC", .search)
        let vc0 = UIStoryboard.nc("navSearchVC", .search)
        let vc1 = UIStoryboard.nc("navFlightSearchOptionsVС", .flight)
        //let vc2 = UIStoryboard.nc("navFlightSearchOptionsVС", .hotel)
        let vc3 = UIStoryboard.nc("navFavoriteHotelListVC", .saved)
        let vc4 = UIStoryboard.nc("navAuthVC", .auth)
        let vc5 = UIStoryboard.nc("navProfileVC", .profile)
        self.viewControllers = [vc0, vc1, vc3, (User.isAuth() ? vc5 : vc4)]
        if let selIndex = selIndex { self.selectedIndex = selIndex }
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        //guard let vc = self.viewControllers![4] else
        //self.viewControllers![4].tabBarItem.title = "Sign in"
    }
}

// MARK: - UITabBarControllerDelegate
extension UITabBarController_app: UITabBarControllerDelegate {
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        guard item.tag == 4 else { return }
//        didSelectProfile?()
//    }
}
