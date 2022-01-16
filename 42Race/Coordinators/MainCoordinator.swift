//
//  MainCoordinator.swift
//  42Race
//
//  Created by Anh Le on 15/01/2022.
//

import Foundation
import UIKit

final class MainCoordinator {
    
    var navigationController: UINavigationController
    private let mainDIContainer: MainDIContainer
    
    init(navigationController: UINavigationController, mainDIContainer: MainDIContainer) {
        self.navigationController = navigationController
        self.mainDIContainer = mainDIContainer
    }
    
    func start() {
        let searchDIContainer = mainDIContainer.makeSearchDIContainer()
        let flow = searchDIContainer.makeSearchCoordinator(navigationController: navigationController)
        flow.start()
    }
}
