//
//  AppDelegate.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.03.2021.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    public var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // IQKeyboardManagerSwift
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        // configureApp
        FacebookHelper.configureApp(application, launchOptions)
        GoogleAuthHelper.configureApp()
        
        // Override point for customization after application launch.
        return true
    }
    // MARK: Background+reachabilityManager
    func applicationDidBecomeActive (_ application: UIApplication) {
        reachabilityManager.startNotifier()
    }
    func applicationWillEnterForeground (_ application: UIApplication) {
        reachabilityManager.stopNotifier()
    }
    // FaceBook
    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        
        let handledFacebook = FacebookHelper.handledFacebook(app, url: url, options: options)
        if handledFacebook { return handledFacebook }
        
        let handledGoogle = GoogleAuthHelper.handledGoogle(app, url: url, options: options)
        if handledGoogle { return handledGoogle }
        
        return true
    }
    // UIInterfaceOrientationMask
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }
}

// MARK: UISceneSession Lifecycle
extension AppDelegate {
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
