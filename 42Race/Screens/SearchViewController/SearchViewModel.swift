//
//  SearchViewModel.swift
//  42Race
//
//  Created by Anh Le on 15/01/2022.
//  Copyright (c) 2022 All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol SearchViewModelDelegate: AnyObject {
    func openFilter(delegate: SearchFilterViewModelDelegate?, defaultFilter: SearchFilterType)
}

protocol SearchViewModelInput {
    var viewDidLoad: PublishRelay<Void> { get }
    var openFilter: PublishRelay<Void> { get }
    var searchText: BehaviorRelay<String> { get }
    var searchRelay: PublishRelay<Void> { get }
}

protocol SearchViewModelOutput {
    var bussinessRelay: BehaviorRelay<[Bussiness]> { get }
    var isLoadingRelay: BehaviorRelay<Bool> { get }
    var filterTypeRelay: BehaviorRelay<SearchFilterType> { get }
}

protocol SearchViewModel: SearchViewModelInput, SearchViewModelOutput { }

class DefaultSearchViewModel: SearchViewModel {
    
    // MARK: - INPUT
    let viewDidLoad = PublishRelay<Void>()
    let openFilter = PublishRelay<Void>()
    let searchText = BehaviorRelay<String>(value: "")
    let searchRelay = PublishRelay<Void>()
    
    // MARK: - OUTPUT
    let bussinessRelay = BehaviorRelay<[Bussiness]>(value: [])
    let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    let filterTypeRelay = BehaviorRelay<SearchFilterType>(value: .term)
    
    // MARK: - Privates
    
    private let disposeBag = DisposeBag()
    private let bussinessService: BussinessServiceType
    private var delegate: SearchViewModelDelegate?
    
    init(bussinessService: BussinessServiceType, delegate: SearchViewModelDelegate?) {
        self.bussinessService = bussinessService
        self.delegate = delegate
        becomeActive()
    }
    
    private func becomeActive() {
        openFilter.subscribe(onNext: { [weak self] in
            self?.delegate?.openFilter(delegate: self, defaultFilter: self?.filterTypeRelay.value ?? .term)
        }).disposed(by: disposeBag)
        
        Observable.merge(viewDidLoad.asObservable(), searchRelay.asObservable())
            .subscribe(onNext: { [weak self] in
            self?.getBussiness()
        }).disposed(by: disposeBag)
    }
    
    private func getBussiness() {
        isLoadingRelay.accept(true)
        let filterType = filterTypeRelay.value
        let text = searchText.value
        var result: Observable<BussinessResponse?>
        switch filterType {
            case .term:
                result = bussinessService.searchByTerm(text)
            case .address:
                result = bussinessService.searchByAddress(text)
            case .phone:
                result = bussinessService.searchByPhone(text)
        }
        result.asSingle()
            .subscribe(onSuccess: { [weak self] reponse in
                self?.isLoadingRelay.accept(false)
                self?.handleBusinessResponse(reponse)
            }, onFailure: { [weak self] error in
                self?.isLoadingRelay.accept(false)
            }).disposed(by: disposeBag)
    }
    
    private func handleBusinessResponse(_ response: BussinessResponse?) {
        guard let response = response else {
            return
        }
        bussinessRelay.accept(response.businesses)
    }
}

extension DefaultSearchViewModel: SearchFilterViewModelDelegate {
    func didSelectFilter(_ type: SearchFilterType) {
        filterTypeRelay.accept(type)
    }
}
