//
//  SearchFilterViewModel.swift
//  42Race
//
//  Created by Anh Le on 16/01/2022.
//  Copyright (c) 2022 All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum SearchFilterType: CaseIterable {
    case term
    case address
    case phone
}

protocol SearchFilterViewModelDelegate: AnyObject {
    func didSelectFilter(_ type: SearchFilterType)
}

protocol SearchFilterViewModelInput {
    func viewDidLoad()
    func didSelect(type: SearchFilterType)
}

protocol SearchFilterViewModelOutput {
    var selectedType: BehaviorRelay<SearchFilterType> { get }
    var searchTypes: BehaviorRelay<[SearchFilterType]> { get }
}

protocol SearchFilterViewModel: SearchFilterViewModelInput, SearchFilterViewModelOutput { }

class DefaultSearchFilterViewModel: SearchFilterViewModel {
    
    // MARK: - INPUT
    // MARK: - OUTPUT
    let selectedType = BehaviorRelay<SearchFilterType>(value: .term)
    let searchTypes = BehaviorRelay<[SearchFilterType]>(value: SearchFilterType.allCases)
    
    private let disposeBag = DisposeBag()
    private weak var delegate: SearchFilterViewModelDelegate?
    
    init(delegate: SearchFilterViewModelDelegate?, defaultFilterType: SearchFilterType) {
        self.delegate = delegate
        self.selectedType.accept(defaultFilterType)
        
        becomeActive()
    }
    
    private func becomeActive() {
        
    }
}

// MARK: - INPUT. View event methods
extension DefaultSearchFilterViewModel {
    func viewDidLoad() {
        
    }
    
    func didSelect(type: SearchFilterType) {
        delegate?.didSelectFilter(type)
    }
}
