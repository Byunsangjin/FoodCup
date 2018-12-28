//
//  MapViewController.swift
//  FoodCup
//
//  Created by Byunsangjin on 27/12/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit
import CoreLocation


class MapViewController: UIViewController, MTMapViewDelegate, CLLocationManagerDelegate {

    // MARK:- Variables
    lazy var mapView: MTMapView = MTMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
    var currentLat: String? // 현재 위치 위도
    var currentLng: String? // 현재 위치 경도
    var radius: String? = "2000" // 반경
    
    // var MapList = [MapDataVO]() // REST API를 이용해 받은 주변 정보
    
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
    
}
