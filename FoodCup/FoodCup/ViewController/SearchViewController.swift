//
//  SearchViewController.swift
//  FoodCup
//
//  Created by Byunsangjin on 04/01/2019.
//  Copyright © 2019 Byunsangjin. All rights reserved.
//

import UIKit
import CoreLocation
import AlamofireObjectMapper
import Alamofire

class SearchViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK:- Variables
    lazy var daumMapView: MTMapView = MTMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
    var mapList = [MapVO]() // REST API를 이용해 받은 주변 정보
    
    var searchWord: String? // 검색어
    var isEnd: Bool? = false // 마지막 페이지인지 아닌지 판단하는 변수, 마지막 페이지 일때 true
    var page: Int = 1 {
        willSet(newPage) {
            if !self.isEnd! { // 마지막 페이지가 아니라면
                self.getMapInfo(searchWord: self.searchWord!, page: self.page)
            }
        }
    }
    var foodContent = FoodContent()
    
    
    
    // MARK:- Constants
    let locationManager = CLLocationManager()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let mapManager = DaumMapManager()
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        // 맵뷰 세팅
        self.mapViewSet()
        
        
    }
    
    
    
    // 맵뷰 세팅 메소드
    func mapViewSet() {
        self.daumMapView.delegate = self
        self.daumMapView.baseMapType = .standard
        
        // 주변 장소 정보 불러오기
        if !self.isEnd! {
            self.getMapInfo(searchWord: self.searchWord!, page: self.page)
        }
        
        self.view.insertSubview(self.daumMapView, at: 0) // 뷰에 맵 추가
    }
    
    
    
    // 주변 장소 정보 받는 메소드
    func getMapInfo(searchWord: String, page: Int) {
        let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
        let headers: HTTPHeaders = [
            "Authorization" : "KakaoAK 1fe5ef0f14fc06810eec67d5775f1117"
        ]
        let params: Parameters = [
            "query" : "\(searchWord)",
            "page" : "\(page)"
        ]
        
        print(page)
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseObject { (response: DataResponse<MapDataDTO>) in
            let addressDTO = response.result.value
            
            if let documents = addressDTO?.document {
                for document in documents {
                    let mapVO = MapVO()
                    
                    // mapVO 객체에 담아 MapList에 추가
                    mapVO.name = document.name!
                    mapVO.phone = document.phone!
                    mapVO.address = document.address!
                    mapVO.roadAddress = document.roadAddress!
                    mapVO.lng = document.lng!
                    mapVO.lat = document.lat!
                    
                    self.mapList.append(mapVO)
                }
            }
            
            self.mapManager.showMarker(daumMapView: self.daumMapView, mapList: self.mapList) // 마커 찍기
            
            if let meta = addressDTO?.meta {
                self.isEnd = meta.isEnd
                self.page = page + 1
            }
        }
    }
    
    
    
    // MARK:- Actions
    @IBAction func okBtnPressed(_ sender: Any) {
        print("self.foodContent.lng : \(self.foodContent.lng)")
        print("self.foodContent.lat : \(self.foodContent.lat)")
        self.delegate.foodContent = self.foodContent
        
        print("self.delegate.foodContent.lng : \(self.delegate.foodContent.lng)")
        print("self.delegate.foodContent.lat : \(self.delegate.foodContent.lat)")
        
        self.navigationController?.popViewController(animated: true)
    }
    
}



// MTMapViewDelegate
extension SearchViewController: MTMapViewDelegate {
    // 마커 클릭 시 동작하는 메소
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        let arr = poiItem.itemName.split(separator: "\n")
        let address = arr[1]
        
        for item in self.mapList {
            if (item.address?.elementsEqual(address))! { // 주소가 같다면
                self.foodContent.lng = item.lng! // 경도
                self.foodContent.lat = item.lat! // 위도
                self.foodContent.name = item.name // 가게 이름
                self.foodContent.address = item.address // 가게 주소
            }
        }
        
        return true
    }
}
