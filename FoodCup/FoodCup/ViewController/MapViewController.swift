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


class MapViewController: UIViewController, MTMapViewDelegate{

    // MARK:- Variables
    lazy var daumMapView: MTMapView = MTMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
    var currentLat: String? // 현재 위치 위도
    var currentLng: String? // 현재 위치 경도
    var radius: String? = "3000" // 반경
    
    var mapList = [MapVO]() // REST API를 이용해 받은 주변 정보
    
    var resultFood: String? // 최종 선택 음식
    
    var page: Int = 1 {
        willSet(newPage) {
            if !self.isEnd! {
                self.getMapInfo(keyword: self.resultFood!, lng: self.currentLng!, lat: self.currentLat!, radius: self.radius!, page: self.page)
            }
        }
    }
    var isEnd: Bool? = false
    
    
    // MARK:- Constants
    let ud = UserDefaults.standard
    let locationManager = CLLocationManager()
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkAuthorization() // 권한 설정 확인
    }
    
    
    
    // 맵 뷰 세팅 메소드
    func mapViewSet() {
        self.daumMapView.delegate = self
        self.daumMapView.baseMapType = .standard
        
        // 뷰에 맵 뷰 추가
        self.view.insertSubview(self.daumMapView, at: 0)
        
        // 현재 위,경도 값 저장
        self.currentLat = String((locationManager.location?.coordinate.latitude)!)
        self.currentLng = String((locationManager.location?.coordinate.longitude)!)
        
        // 트랙킹 모드 & 나침반 모드 ON
        self.daumMapView.currentLocationTrackingMode = .onWithoutHeading
        
        
        
        // 주변 장소 정보 불러오기
        self.getMapInfo(keyword: self.resultFood!, lng: self.currentLng!, lat: self.currentLat!, radius: self.radius!, page: self.page)
    }

    
    
    // 주변 장소 정보 받는 메소드
    func getMapInfo(keyword: String, lng x: String, lat y: String, radius: String, page: Int) {
        let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
        let headers: HTTPHeaders = [
            "Authorization" : "KakaoAK 1fe5ef0f14fc06810eec67d5775f1117"
        ]
        let params: Parameters = [
            "query" : "\(keyword)",
            "x" : "\(x)",
            "y" : "\(y)",
            "radius" : "\(radius)",
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
                    mapVO.lng = document.lng!
                    mapVO.lat = document.lat!
                    
                    self.mapList.append(mapVO)
                }
            }
            
            DaumMapManager.shared.showMarker(daumMapView: self.daumMapView, mapList: self.mapList) // 마커 찍기
            
            if let meta = addressDTO?.meta {
                self.isEnd = meta.isEnd
                self.page = page + 1
            }
        }
    }
    
    
    
    // MARK:- Actions
    @IBAction func homeBtnPressed(_ sender: Any) {
    }
    
}



extension MapViewController: CLLocationManagerDelegate {
    // 위치 사용 인증 요청 메소드
    func requestAuthorization() {
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization() //권한 요청
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }
    
    
    
    // 권한 설정이 바뀌었을 때
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            self.okAlert("위치 접근을 허용해 주세요", "설정 -> FoodCup -> 위치 -> 앱을 사용하는 동안")
        } else if status == .authorizedWhenInUse {            
            self.mapViewSet() // 맵뷰 세팅
        }
    }
    
    
    
    // 위치 권한 체크하는 메소드
    func checkAuthorization() {
        if CLLocationManager.authorizationStatus() == .denied { // 권한 거부 일 때
            self.okAlert("위치 접근을 허용해 주세요", "설정 -> FoodCup -> 위치 -> 앱을 사용하는 동안") {
                self.dismiss(animated: true, completion: nil)
            }
        } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse { // 권한 허용 일 때
            self.mapViewSet() // 맵뷰 세팅
        } else { // 권한을 설정하지 않았다면
            self.requestAuthorization()
        }
    }
}
