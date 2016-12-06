//
//  AppDelegate.swift
//  WeiBoComposeDemo
//
//  Created by Vitas on 2016/12/6.
//  Copyright © 2016年 Vitas. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainViewController = WBComposeViewController()
        let navController = UINavigationController(rootViewController: mainViewController)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }

}

