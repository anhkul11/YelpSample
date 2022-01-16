//
//  AppDelegate.swift
//  42Race
//
//  Created by Anh Le on 15/01/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainDIContainer = MainDIContainer()
    var mainCoordinator: MainCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        
        mainCoordinator = MainCoordinator(navigationController: navigationController, mainDIContainer: mainDIContainer)
        mainCoordinator?.start()
        
        window?.makeKeyAndVisible()
        
        return true
    }
}

