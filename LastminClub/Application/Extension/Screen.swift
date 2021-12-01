//
//  Screen.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 27.04.2021.
//

import UIKit

public struct Screen {
    static var width: CGFloat { return UIScreen.main.bounds.width }
    static var height: CGFloat { return UIScreen.main.bounds.height }
    
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    static var topSafeArea: CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            return window?.safeAreaInsets.top ?? 0
        } else {
            let root = UIApplication.shared.keyWindow?.rootViewController
            return root?.topLayoutGuide.length ?? 0
        }
    }
    static var bottomSafeArea: CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            return window?.safeAreaInsets.bottom ?? 0
        } else {
            let root = UIApplication.shared.keyWindow?.rootViewController
            return root?.bottomLayoutGuide.length ?? 0
        }
    }
    //
    static func tabBarHeight(_ vc: UIViewController) -> CGFloat {
        return vc.tabBarController?.tabBar.frame.height ?? 0
    }
    static func workHeight(_ vc: UIViewController) -> CGFloat {
        return (Screen.height - Screen.topSafeArea - Screen.tabBarHeight(vc))
    }
}

// MARK: -
extension Screen {
    //https://stackoverflow.com/questions/28938660/how-to-lock-orientation-of-one-view-controller-to-portrait-mode-only-in-swift
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    /*
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Screen.lockOrientation(.portrait)
        // Or to rotate and lock
        // Screen.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Screen.lockOrientation(.all) // Don't forget to reset when view is being removed
    }
     */
}
