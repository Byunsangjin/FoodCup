//
//  FoodContent.swift
//  FoodCup
//
//  Created by Byunsangjin on 07/01/2019.
//  Copyright © 2019 Byunsangjin. All rights reserved.
//

import Foundation

class FoodContent: NSObject {
    @objc var name: String? = "" // 가게명
    @objc var address: String? = ""// 주소
    @objc var text: String? // 메모
    var image: UIImage? = UIImage(named: "defaultImage.png")// 이미지
    @objc var lat: String? = "" // 위도
    @objc var lng: String? = ""// 경도
    @objc var imgUrl: String? // 이미지 경로
}
