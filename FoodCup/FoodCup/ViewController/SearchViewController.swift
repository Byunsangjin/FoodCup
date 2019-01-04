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

class SearchViewController: UIViewController, MTMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK:- Variables
    lazy var mapView: MTMapView = MTMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
    var currentLat: String? // 현재 위치 위도
    var currentLng: String? // 현재 위치 경도
    var radius: String? = "2000" // 반경
    
    var MapList = [MapVO]() // REST API를 이용해 받은 주변 정보
    
    var searchWord: String? // 검색어
    var page: Int = 1 {
        willSet(newPage) {
            if !self.isEnd! {
                print(self.isEnd)
                self.getMapInfo(keword: self.searchWord!, lng: self.currentLng!, lat: self.currentLat!, radius: self.radius!, page: self.page)
            }
        }
        
        didSet(oldPage) {
            
        }
    }
    
    var isEnd: Bool? = false
    
    var items = [MTMapPOIItem]()
    
    // MARK:- Constants
    let locationManager = CLLocationManager()
    let ud = UserDefaults.standard
    
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 권한 설정 확인
        self.checkAuthorization()
        
        // 뷰에 맵 추가
        self.view.insertSubview(self.mapView, at: 0)
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkAuthorization()
    }
    
    
    
    // 권한 설정이 바뀌었을 때
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            self.alert("위치 접근을 허용해 주세요", "설정 -> FoodCup -> 위치 -> 앱을 사용하는 동안")
        } else if status == .authorizedWhenInUse {
            // 맵뷰 세팅
            self.mapViewSet()
            
            // 주변 장소 정보 불러오기
            if !self.isEnd! {
                print(self.isEnd)
                self.getMapInfo(keword: self.searchWord!, lng: self.currentLng!, lat: self.currentLat!, radius: self.radius!, page: self.page)
            }
        }
    }
    
    
    
    // 위치 권한 체크하는 메소드
    func checkAuthorization() {
        if CLLocationManager.authorizationStatus() == .denied { // 권한 거부 일 때
            self.alert("위치 접근을 허용해 주세요", "설정 -> FoodCup -> 위치 -> 앱을 사용하는 동안")
        } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse { // 권한 허용 일 때
            // 맵뷰 세팅
            self.mapViewSet()
            
            // 주변 장소 정보 불러오기
            if !self.isEnd! {
                print(self.isEnd)
                self.getMapInfo(keword: self.searchWord!, lng: self.currentLng!, lat: self.currentLat!, radius: self.radius!, page: self.page)
            }
        } else { // 권한을 설정하지 않았다면
            self.requestAuthorization()
            
        }
    }
    
    
    
    // 위치 사용 인증 요청 메소드
    func requestAuthorization() {
        //현재위치 가져오기
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization() //권한 요청
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }
    
    
    
    // 맵뷰 세팅 메소드
    func mapViewSet() {
        self.mapView.delegate = self
        self.mapView.baseMapType = .standard
        
        // 현재 위,경도 값 저장
        self.currentLat = String((locationManager.location?.coordinate.latitude)!)
        self.currentLng = String((locationManager.location?.coordinate.longitude)!)
    }
    
    
    
    // 마커 생성 메소드
    func poiItem(name: String, latitude: Double, longitude: Double) -> MTMapPOIItem {
        let poiItem = MTMapPOIItem()
        poiItem.itemName = name
        poiItem.markerType = .redPin
        //        poiItem.customImage = UIImage(named: "gps_button") //커스텀 이미지 지정
        poiItem.mapPoint = MTMapPoint(geoCoord: .init(latitude: latitude, longitude: longitude))
        poiItem.showAnimationType = .springFromGround
        //        poiItem.customImageAnchorPointOffset = .init(offsetX: 30, offsetY: 0)
        
        return poiItem
    }
    
    
    
    // 주변 장소 정보 받는 메소드
    func getMapInfo(keword keyword: String, lng x: String, lat y: String, radius: String, page: Int) {
        let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
        let headers: HTTPHeaders = [
            "Authorization" : "KakaoAK 1fe5ef0f14fc06810eec67d5775f1117"
        ]
        let params: Parameters = [
            "query" : "\(keyword)",
            "page" : "\(page)"
        ]
        
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
                    mapVO.x = (Double(document.x!))!
                    mapVO.y = (Double(document.y!))!
                    
                    self.MapList.append(mapVO)
                }
            }
            
            // 마커 찍기
            self.showMarker()
            
            if let meta = addressDTO?.meta {
                self.isEnd = meta.isEnd
                self.page = page + 1
            }
        }
    }
    
    
    
    // 받아온 장소정보를 이용해 마커를 띄워준다.
    func showMarker() {
        //var items = [MTMapPOIItem]() // 마커 배열
        
        // 주변 장소 마커 추가
        for data in self.MapList {
            items.append(self.poiItem(name: data.name!, latitude: data.y!, longitude: data.x!))
        }
        
        self.mapView.addPOIItems(items) // 맵뷰에 마커 추가
        self.mapView.fitAreaToShowAllPOIItems() // 모든 마커가 보이게 카메라 위치/줌 조정
    }
    
    
    
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        print(poiItem.itemName)
        
        return true
    }
    
    
    
    // MARK:- Actions
    @IBAction func okBtnPressed(_ sender: Any) {
        ud.setValue("돈카2014", forKey: "searchWord")
        self.dismiss(animated: true, completion: nil)
    }
    
}
