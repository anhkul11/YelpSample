//
//  MainDIContainer.swift
//  42Race
//
//  Created by Anh Le on 15/01/2022.
//

import Foundation
final class MainDIContainer {
    
    // MARK: - DIContainers of scenes
    func makeSearchDIContainer() -> SearchDIContainer {
        let businessService = BussinessService()
        let dependencies = SearchDIContainer.Dependencies(bussinessService: businessService)
        return SearchDIContainer(dependencies: dependencies)
    }
}
