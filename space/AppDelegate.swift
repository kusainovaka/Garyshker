//
//  AppDelegate.swift
//  space
//
//  Created by Kamila Kusainova on 26.06.17.
//  Copyright © 2017 sdu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: screenBounds)
        window?.rootViewController = GameViewController()
        window?.makeKeyAndVisible()
        UIApplication.shared.isStatusBarHidden = true
        return true
    }

}

