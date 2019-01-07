//
//  FoodContent.swift
//  FoodCup
//
//  Created by Byunsangjin on 07/01/2019.
//  Copyright © 2019 Byunsangjin. All rights reserved.
//

import Foundation

class FoodContent: NSObject {
    @objc var name: String? // 가게명
    @objc var address: String? // 주소
    @objc var text: String? // 메모
    @objc var image: UIImage? // 이미지
    var lat: Double? // 위도
    var lng: Double? // 경도
}
