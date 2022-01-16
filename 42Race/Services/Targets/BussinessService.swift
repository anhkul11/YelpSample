//
//  BussinessService.swift
//  42Race
//
//  Created by Anh Le on 15/01/2022.
//

import Foundation
import RxSwift

protocol BussinessServiceType: BaseServiceType {
    func searchByTerm(_ term: String) -> Observable<BussinessResponse?>
    func searchByAddress(_ address: String) -> Observable<BussinessResponse?>
    func searchByPhone(_ phone: String) -> Observable<BussinessResponse?>
}

final class BussinessService: BussinessServiceType {
    let resultScheduler: SchedulerType
    
    public init( resultScheduler: SchedulerType = MainScheduler.instance) {
        self.resultScheduler = resultScheduler
    }
}

extension BussinessService {
    func searchByTerm(_ term: String) -> Observable<BussinessResponse?> {
        return BussinessTarget.TermSearch(term: term)
            .execute()
            .observe(on: resultScheduler)
    }
    func searchByAddress(_ address: String) -> Observable<BussinessResponse?> {
        return BussinessTarget.TermSearch(term: "", location: address)
            .execute()
            .observe(on: resultScheduler)
    }
    
    func searchByPhone(_ phone: String) -> Observable<BussinessResponse?> {
        return BussinessTarget.PhoneSearch(phone: phone)
            .execute()
            .observe(on: resultScheduler)
    }
}
