//
//  AppDelegate.swift
//  DirectPaymentSDKDemo
//
//  Created by Hitendrakumar Solanki on 17/12/20.
//  Copyright © 2020 PhonePe. All rights reserved.
//

import UIKit
import DirectPaymentSDK
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        //Process your own deeplinks here
        return true
    }
}

