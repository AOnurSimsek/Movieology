//
//  AppDelegate.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 11.08.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let vc = ViewController()
        window = UIWindow()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }

}

