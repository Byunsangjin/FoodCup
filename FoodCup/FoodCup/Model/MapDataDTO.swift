//
//  MapModel.swift
//  FoodCup
//
//  Created by Byunsangjin on 28/12/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit
import ObjectMapper

// 받아온 JSON 객체를 사용하기 쉽게 매핑하는 클래스
class MapDataDTO: Mappable {
    
    // MARK:- Variables
    var document: [Document]?
    var meta: Meta?
    
    
    
    // MARK:- Methods
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        document <- map["documents"]
        meta <- map["meta"]
    }
    
    
    class Document: Mappable {
        var address: String?
        var roadAddress: String?
        var name: String?
        var phone: String?
        var lng: String?
        var lat: String?
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            name <- map["place_name"]
            phone <- map["phone"]
            address <- map["address_name"]
            roadAddress <- map["road_address_name"]
            lng <- map["x"]
            lat <- map["y"]
            
        }
    }
    
    
    
    class Meta: Mappable {
        var pageCount: Int?
        var totalCount: Int?
        var isEnd: Bool?
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            pageCount <- map["pageable_count"]
            totalCount <- map["total_count"]
            isEnd <- map["is_end"]
        }
        
        
    }
}
