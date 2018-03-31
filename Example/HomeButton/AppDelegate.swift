//
//  AppDelegate.swift
//  HomeButton
//
//  Created by nathangitter on 03/16/2018.
//  Copyright (c) 2018 nathangitter. All rights reserved.
//

import UIKit
import HomeButton

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        HomeButton.style = .classic
        return true
    }

}
