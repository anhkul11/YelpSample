//
//  SearchCoordinator.swift
//  42Race
//
//  Created by Anh Le on 15/01/2022.
//

import Foundation
import UIKit
protocol SearchCoordinatorDependencies {
    func makeSearchViewController(delegate: SearchViewModelDelegate?) -> SearchViewController
    func makeSearchFilterViewController(delegate: SearchFilterViewModelDelegate?, defaultFilter: SearchFilterType) -> SearchFilterViewController
}

final class SearchCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: SearchCoordinatorDependencies
    
    init(navigationController: UINavigationController,
         dependencies: SearchCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let vc = dependencies.makeSearchViewController(delegate: self)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - SearchViewModelDelegate
extension SearchCoordinator: SearchViewModelDelegate {
    func openFilter(delegate: SearchFilterViewModelDelegate?, defaultFilter: SearchFilterType) {
        let vc = dependencies.makeSearchFilterViewController(delegate: delegate, defaultFilter: defaultFilter)
        vc.modalPresentationStyle = .popover
        navigationController?.present(vc, animated: true, completion: nil)
    }
}
