//
//  AppDelegate.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 11.08.2022.
//

import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Search"

        window = UIWindow()
        window?.rootViewController =  MainScreenViewController()
        window?.makeKeyAndVisible()
        return true
    }

}

