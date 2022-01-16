//
//  DIContainer.swift
//  42Race
//
//  Created by Anh Le on 15/01/2022.
//

import Foundation
import UIKit

final class SearchDIContainer {
    struct Dependencies {
        let bussinessService: BussinessServiceType
    }
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - FlowCoordinator
    func makeSearchCoordinator(navigationController: UINavigationController) -> SearchCoordinator {
        return SearchCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension SearchDIContainer: SearchCoordinatorDependencies {
    private func makeSearchViewModel(delegate: SearchViewModelDelegate?) -> SearchViewModel {
        return DefaultSearchViewModel(bussinessService: dependencies.bussinessService, delegate: delegate)
    }
    
    func makeSearchViewController(delegate: SearchViewModelDelegate?) -> SearchViewController {
        let viewModel = makeSearchViewModel(delegate: delegate)
        return SearchViewController.create(with: viewModel)
    }
    
    func makeSearchFilterViewController(delegate: SearchFilterViewModelDelegate?, defaultFilter: SearchFilterType) -> SearchFilterViewController {
        let viewModel = DefaultSearchFilterViewModel(delegate: delegate, defaultFilterType: defaultFilter)
        return SearchFilterViewController.create(with: viewModel)
    }
}
