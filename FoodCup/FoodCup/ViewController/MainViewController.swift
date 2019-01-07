//
//  MainViewController.swift
//  FoodCup
//
//  Created by Byunsangjin on 26/12/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK:- Outlets
    @IBOutlet var bgImageView: UIImageView!
    
    
    
    // MARK:- Constants
    let userDefaults = UserDefaults.standard
    let locationManager = CLLocationManager()


    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경 이미지 설정
        self.bgImageView.image = UIImage(named: "background")
        
    }
    
    
    
    // MARK:- Actions
    @IBAction func worldCupPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "WorldCup", bundle: nil)
        let worldCupVC = storyboard.instantiateViewController(withIdentifier: "WorldCupViewController") as! WorldCupViewController
        
        self.present(worldCupVC, animated: true)
    }
    
    
    
    @IBAction func resultPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Result", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
        
        // 이전에 선택한 음식 결과
        let result = self.userDefaults.string(forKey: "result")
        resultVC.result = result
        
        self.present(resultVC, animated: true)
    }
    
    
    
    @IBAction func randomBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Random", bundle: nil)
        let randomVC = storyboard.instantiateViewController(withIdentifier: "RandomViewController") as! RandomViewController

        self.present(randomVC, animated: true)
    }
    
    
    
    // 게시판 버튼 클릭시
    @IBAction func boardBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        self.present(loginVC, animated: true)
    }
    
    
    
    
    // UnWind 세그웨이
    @IBAction func gotoMainVC(_ sender: UIStoryboardSegue) {
        
    }
    
    
}
