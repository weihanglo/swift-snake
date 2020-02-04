//
//  AppDelegate.swift
//  swift-snake
//
//  Created by Weihang Lo on 7/4/16.
//  Copyright © 2016 Weihang Lo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let vc = ViewController()
        
        window = UIWindow()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }
}

