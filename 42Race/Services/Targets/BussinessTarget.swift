//
//  BussinessTarget.swift
//  42Race
//
//  Created by Anh Le on 15/01/2022.
//

import Foundation
import Alamofire
import ObjectMapper

enum BussinessTarget {
    struct TermSearch: Requestable {
        typealias Output = BussinessResponse?
        
        var httpMethod: HTTPMethod { return .get }
        var endpoint: String { return "/v3/businesses/search"}
        var params: Parameters {
            let dict: Parameters = ["term": term,
                                    "location": location]
            return dict
        }
        
        let term: String
        var location: String = "San Francisco"
        
        func decode(data: Any) -> BussinessResponse? {
            return Mapper<BussinessResponse>().map(JSONObject: data) ?? nil
        }
    }
    
    struct PhoneSearch: Requestable {
        typealias Output = BussinessResponse?
        
        var httpMethod: HTTPMethod { return .get }
        var endpoint: String { return "/v3/businesses/search/phone"}
        var params: Parameters {
            let dict: Parameters = ["phone": phone,
                                    "locale": locale]
            return dict
        }
        
        let phone: String
        var locale: String = "en_US"
        
        func decode(data: Any) -> BussinessResponse? {
            return Mapper<BussinessResponse>().map(JSONObject: data) ?? nil
        }
    }
}
