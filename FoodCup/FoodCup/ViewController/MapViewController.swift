//
//  MapViewController.swift
//  FoodCup
//
//  Created by Byunsangjin on 27/12/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit
import CoreLocation
import AlamofireObjectMapper
import Alamofire


class MapViewController: UIViewController, MTMapViewDelegate, CLLocationManagerDelegate {

    // MARK:- Variables
    lazy var mapView: MTMapView = MTMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
    var currentLat: String? // 현재 위치 위도
    var currentLng: String? // 현재 위치 경도
    var radius: String? = "2000" // 반경
    
    var MapList = [MapVO]() // REST API를 이용해 받은 주변 정보
    
    var resultFood: String? // 최종 선택 음식
    
    
    
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
        
        // 주변 장소
        self.getMapInfo(keword: self.resultFood!, lng: self.currentLng!, lat: self.currentLat!, radius: self.radius!)
    }
    
    
    
    // 권한 설정이 바뀌었을 때
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            self.alert("위치 접근을 허용해 주세요", "설정 -> FoodCup -> 위치 -> 앱을 사용하는 동안")
        } else if status == .authorizedWhenInUse {
            // 맵뷰 세팅
            self.mapViewSet()
        }
    }
    
    
    
    // 위치 권한 체크하는 메소드
    func checkAuthorization() {
        if CLLocationManager.authorizationStatus() == .denied { // 권한 거부 일 때
            self.alert("위치 접근을 허용해 주세요", "설정 -> FoodCup -> 위치 -> 앱을 사용하는 동안")
        } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse { // 권한 허용 일 때
            // 맵뷰 세팅
            self.mapViewSet()
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
        
        // 트랙킹 모드 & 나침반 모드 ON
        self.mapView.currentLocationTrackingMode = .onWithoutHeading
    }

    
    
    // 마커 생성 메소드
    func poiItem(name: String, latitude: Double, longitude: Double) -> MTMapPOIItem {
        let poiItem = MTMapPOIItem()
        poiItem.itemName = name
        poiItem.markerType = .customImage //커스텀 타입으로 변경
        
        if name.elementsEqual("현재위치") == true {
            //poiItem.customImage = UIImage(named: "user_marker3") //커스텀 이미지 지정
        } else {
            poiItem.customImage = UIImage(named: "gps_button") //커스텀 이미지 지정
        }
        
        poiItem.markerSelectedType = .customImage //선택 되었을 때 마커 타입
        poiItem.customSelectedImage = UIImage(named: "user_marker3") //선택 되었을 때 마커 이미지 지정
        poiItem.mapPoint = MTMapPoint(geoCoord: .init(latitude: latitude, longitude: longitude))
        poiItem.showAnimationType = .noAnimation
        poiItem.customImageAnchorPointOffset = .init(offsetX: 30, offsetY: 0)
        
        return poiItem
    }
    
    
    
    // 주변 장소 정보 받는 메소드
    func getMapInfo(keword keyword: String, lng x: String, lat y: String, radius: String) {
        let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
        let headers: HTTPHeaders = [
            "Authorization" : "KakaoAK 1fe5ef0f14fc06810eec67d5775f1117"
        ]
        let params: Parameters = [
            "query" : "\(keyword)",
            "x" : "\(x)",
            "y" : "\(y)",
            "radius" : "\(radius)"
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
        }
    }
    
    
    
    // 받아온 장소정보를 이용해 마커를 띄워준다.
    func showMarker() {
        var items = [MTMapPOIItem]() // 마커 배열
        //items.append(self.poiItem(name: "현재위치", latitude: Double(self.currentLat!)!, longitude: Double(self.currentLng!)!)) // 현재 위치 마커 추가
        
        // 주변 장소 마커 추가
        for data in self.MapList {
            items.append(self.poiItem(name: data.name!, latitude: data.y!, longitude: data.x!))
        }
        
        self.mapView.addPOIItems(items) // 맵뷰에 마커 추가
        self.mapView.fitAreaToShowAllPOIItems() // 모든 마커가 보이게 카메라 위치/줌 조정
    }
    
    
}
