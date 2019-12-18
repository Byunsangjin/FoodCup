//
//  MainViewController.swift
//  FoodCup
//
//  Created by Byunsangjin on 26/12/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit
import CoreLocation
import Hero
import GoogleMobileAds

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK:- Outlets
    @IBOutlet var bgImageView: UIImageView!
    @IBOutlet var bannerView: GADBannerView!
    
    
    
    // MARK:- Constants
    let userDefaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    let ud = UserDefaults.standard
    let adID : String? = "ca-app-pub-9096146193275422/8881619691"
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경 이미지 설정
        self.bgImageView.image = UIImage(named: "mainBackground.png")
        
        self.bannerView.adUnitID = adID
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
    }
    
    
    
    // MARK:- Actions
    @IBAction func worldCupPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "WorldCup", bundle: nil)
        let worldCupVC = storyboard.instantiateViewController(withIdentifier: "WorldCupViewController") as! WorldCupViewController
        worldCupVC.modalPresentationStyle = .fullScreen
        
        self.present(worldCupVC, animated: true)
    }
    
    
    
    @IBAction func resultPressed(_ sender: Any) {
        // 이전에 선택한 음식 결과
        guard let result = self.userDefaults.string(forKey: "result") else {
            self.okAlert("이전에 선택한 음식이 없습니다.", nil)
            return
        }
        
        let storyboard = UIStoryboard.init(name: "Result", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
        resultVC.modalPresentationStyle = .fullScreen
        
        resultVC.result = result
        
        self.present(resultVC, animated: true)
    }
    
    
    
    @IBAction func randomBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Random", bundle: nil)
        let randomVC = storyboard.instantiateViewController(withIdentifier: "RandomViewController") as! RandomViewController
        randomVC.modalPresentationStyle = .fullScreen
        
        self.present(randomVC, animated: true)
    }
    
    
    
    // 게시판 버튼 클릭시
    @IBAction func boardBtnPressed(_ sender: Any) {
        if self.ud.bool(forKey: "isSignIn") { // 로그인 상태라면
            let storyboard = UIStoryboard.init(name: "FoodList", bundle: nil)
            let foodListVC = storyboard.instantiateViewController(withIdentifier: "FoodListViewController") as! FoodListViewController
            
            foodListVC.modalPresentationStyle = .fullScreen
            foodListVC.hero.isEnabled = true
            foodListVC.hero.modalAnimationType = .selectBy(presenting: .pull(direction: .left), dismissing: .pull(direction: .right))
            
            self.present(foodListVC, animated: true)
        } else {
            let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            loginVC.modalPresentationStyle = .fullScreen
            loginVC.hero.isEnabled = true
            loginVC.hero.modalAnimationType = .selectBy(presenting: .pull(direction: .left), dismissing: .pull(direction: .right))
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    
    
    // UnWind 세그웨이
    @IBAction func gotoMainVC(_ sender: UIStoryboardSegue) {
        
    }
}
