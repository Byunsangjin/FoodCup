//
//  AddListViewController.swift
//  FoodCup
//
//  Created by Byunsangjin on 31/12/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import AlamofireObjectMapper

class AddListViewController: UIViewController, MTMapViewDelegate, CLLocationManagerDelegate {
    // MARK:- Outlets
    @IBOutlet var mapButton: UIButton!
    @IBOutlet var searchTextField: UITextField!
    
    @IBOutlet var mapView: UIView!
    
    
    
    // MARK:- Variables
    lazy var alertMap: MTMapView = MTMapView(frame: CGRect(x: 0, y: 0, width: self.mapView.frame.width, height: self.mapView.frame.height)) // 다음 맵 뷰
    
    var currentLat: String? // 현재 위치 위도
    var currentLng: String? // 현재 위치 경도
    
    var MapList = [MapVO]() // REST API를 이용해 받은 주변 정보
    
    
    
    // MARK:- Constants
    let locationManager = CLLocationManager()
    
    let mapAlert = UIAlertController(title: nil, message: "지도", preferredStyle: .alert) // 맵 alert
    let mapVC = UIViewController() // contentViewController에 들어갈 ViewController
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkAuthorization()
        
        // alert 세팅
        mapVC.preferredContentSize.height = 300 // 알림창 높이 설정
        mapVC.view = self.alertMap
        
        mapAlert.addAction(UIAlertAction(title: "저장", style: .default) { (_) in
            // 저장 Action
            self.mapView.reloadInputViews()
        })
        mapAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
        // 알림 창 contentVC에 ViewController 추가
        mapAlert.setValue(mapVC, forKey: "contentViewController")
        
        self.mapView.insertSubview(self.alertMap, at: 0)
    }
    
    
    
    // 맵뷰 세팅 메소드
    func mapViewSet() {
        self.alertMap.delegate = self
        self.alertMap.baseMapType = .standard
        
        // 현재 위,경도 값 저장
        self.currentLat = String((locationManager.location?.coordinate.latitude)!)
        self.currentLng = String((locationManager.location?.coordinate.longitude)!)
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
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization() //권한 요청
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }
    
    
    
    // 마커 생성 메소드
    func poiItem(name: String, address: String, latitude: Double, longitude: Double) -> MTMapPOIItem {
        let poiItem = MTMapPOIItem()
        
        poiItem.itemName = name + "\n" + address
        poiItem.markerType = .redPin
        poiItem.mapPoint = MTMapPoint(geoCoord: .init(latitude: latitude, longitude: longitude))
        poiItem.showAnimationType = .springFromGround
        
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
        
        self.alertMap.removeAllPOIItems()
        
        // 주변 장소 마커 추가
        for data in self.MapList {
            items.append(self.poiItem(name: data.name!, address: data.address!, latitude: data.y!, longitude: data.x!))
        }
        
        self.alertMap.addPOIItems(items) // 맵뷰에 마커 추가
        self.alertMap.fitAreaToShowAllPOIItems() // 모든 마커가 보이게 카메라 위치/줌 조정
    }
    
    
    
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        print(poiItem.mapPoint.mapPointGeo().latitude)
        print(poiItem.mapPoint.mapPointGeo().latitude)
        return true
    }
    
    
    
    // MARK:- Actions
    @IBAction func mapBtnPressed(_ sender: Any) {
        
        self.MapList.removeAll()
        self.getMapInfo(keword: self.searchTextField.text!, lng: self.currentLng!, lat: self.currentLat!, radius: "2000")
        
        self.present(mapAlert, animated: true)
    }
    
}
