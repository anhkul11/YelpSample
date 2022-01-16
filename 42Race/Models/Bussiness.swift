//
//  Bussiness.swift
//  42Race
//
//  Created by Anh Le on 15/01/2022.
//

import Foundation
import ObjectMapper

struct BussinessResponse: Mappable {
    var total: Int?
    var businesses: [Bussiness] = []
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        total <- map["total"]
        businesses <- map["businesses"]
    }
}

struct Bussiness: Mappable {
    var id: String?
    var name: String?
    var phone: String?
    var displayPhone: String?
    var displayAddress: [String] = []
    var categories: [String] = []
    var isClosed: Bool = false
    var imageURLString: String?
    var rating: Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        phone <- map["phone"]
        displayPhone <- map["display_phone"]
        displayAddress <- map["location.display_address"]
        categories <- map["categories.title"]
        isClosed <- map["is_closed"]
        imageURLString <- map["image_url"]
        rating <- map["rating"]
    }
}
