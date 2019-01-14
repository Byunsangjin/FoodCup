//
//  DetailViewController.swift
//  FoodCup
//
//  Created by Byunsangjin on 31/12/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, MTMapViewDelegate {
    // MARK:- Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var mapView: UIView!
    
    
    
    // MARK:- Variables
    var foodContent: FoodContent?
    lazy var daumMapView: MTMapView = MTMapView(frame: CGRect(x: 0, y: 0, width: self.mapView.frame.width, height: self.mapView.frame.height)) // 다음 맵 뷰
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = self.foodContent?.image
        self.textView.text = self.foodContent?.text
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if (self.foodContent!.lng?.isEmpty)! != true { // 좌표 값이 비어있지 않다면
            self.mapViewSet()
            DaumMapManager.shared.showMarker(daumMapView: self.daumMapView, foodContent: self.foodContent!) // 맵에 마커를 찍는다.
        }
    }
    
    
    
    // 맵뷰 세팅 메소드
    func mapViewSet() {
        self.daumMapView.delegate = self
        self.daumMapView.baseMapType = .standard
        
        self.mapView.addSubview(self.daumMapView)
    }
}
