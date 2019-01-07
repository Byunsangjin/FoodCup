//
//  DaumMapManager.swift
//  FoodCup
//
//  Created by Byunsangjin on 07/01/2019.
//  Copyright © 2019 Byunsangjin. All rights reserved.
//

class DaumMapManager {
    // 마커 생성 메소드
    func poiItem(name: String, address: String,latitude: Double, longitude: Double) -> MTMapPOIItem {
        let poiItem = MTMapPOIItem()
        
        poiItem.itemName = name + "\n\(address)"
        poiItem.markerType = .redPin
        poiItem.mapPoint = MTMapPoint(geoCoord: .init(latitude: latitude, longitude: longitude))
        poiItem.showAnimationType = .springFromGround
        
        return poiItem
    }
    
    
    
    // foodContent정보를 이용해 마커를 띄워준다.
    func showMarker(daumMapView: MTMapView, foodContent: FoodContent) {
        var items = [MTMapPOIItem]() // 마커 배열
        
        items.append(self.poiItem(name: foodContent.name!, address: foodContent.address!, latitude: foodContent.lat!, longitude: foodContent.lng!))
        
        daumMapView.addPOIItems(items) // 맵뷰에 마커 추가
        daumMapView.fitAreaToShowAllPOIItems() // 모든 마커가 보이게 카메라 위치/줌 조정
    }
    
    
    
    // MapList를 이용해 마커를 띄워준다
    func showMarker(daumMapView: MTMapView, mapList: [MapVO]) {
        var items = [MTMapPOIItem]() // 마커 배열
        
        // 주변 장소 마커 추가
        for data in mapList {
            items.append(self.poiItem(name: data.name!, address: data.address!, latitude: data.lat!, longitude: data.lng!))
        }
        
        daumMapView.addPOIItems(items) // 맵뷰에 마커 추가
        daumMapView.fitAreaToShowAllPOIItems() // 모든 마커가 보이게 카메라 위치/줌 조정
    }    
}
