//
//  AppDelegate.swift
//  ADCoordinator
//
//  Created by Pierre Felgines on 02/14/2020.
//  Copyright (c) 2020 Pierre Felgines. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var applicationCoordinator: ApplicationCoordinator?

    func application(_ application: UIApplication,
                     // swiftlint:disable:next discouraged_optional_collection
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let navigationController = UINavigationController()
        applicationCoordinator = ApplicationCoordinator(navigationController: navigationController)
        applicationCoordinator?.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        return true
    }
}
