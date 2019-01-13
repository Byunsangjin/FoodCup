//
//  RandomViewController.swift
//  FoodCup
//
//  Created by Byunsangjin on 29/12/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit

class RandomViewController: UIViewController {

    // MARK:- Outlets
    @IBOutlet var bgImageView: UIImageView!
    @IBOutlet var randomImageView: UIImageView!
    @IBOutlet var stopButton: UIButton!
    
    
    
    // MARK:- Variables
    var foodList = ["간장게장", "김밥", "김치찌개", "냉면", "닭발", "돈까스", "떡볶이", "보쌈", "부대찌개", "삼겹살", "순대", "순대국", "양꼬치", "족발", "짬뽕", "치킨", "탕수육", "파스타"]
    var resultFood: String?
    
    
    // MARK:- Constants
    let ud = UserDefaults.standard
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bgImageView.image = UIImage(named: "randomBackground.png")
        
        // 첫 음식 사진
        self.randomImageView.image = UIImage(named: self.foodList[Int.random(in: 0...self.foodList.count-1)])
        
        // 애니메이션 이미지 배열 정의
        var imageArr = [UIImage]()
        for data in self.foodList {
            imageArr.append(UIImage(named: data)!)
        }
        
        // 애니메이션 이미지 배열
        self.randomImageView.animationImages = imageArr
        
        // 애니메이션 속성 설정
        self.randomImageView.animationDuration = 1.2
        
        // 애니메이션 시작
        self.randomImageView.startAnimating()
        
        // 결과 음식 이미지 설정
        let rand = Int.random(in: 0...self.foodList.count-1)
        self.resultFood = foodList[rand]
        self.randomImageView.image = UIImage(named: self.resultFood!)
        
        self.ud.set(self.resultFood, forKey: "resultFood")
    }
    
    
    
    // MARK:- Actions
    @IBAction func stopBtnPressed(_ sender: UIButton) {
        if self.stopButton.tag == 0 { // Stop버튼 클릭 시
            // 애니메이션 멈추고 버튼 텍스트 변경
            self.randomImageView.stopAnimating()
            self.stopButton.setTitle("음식점 찾기", for: .normal)
            
            // 태그 변경
            self.stopButton.tag = 1
        } else { // 주변 위치 확인 버튼 클릭 시
            let storyboard = UIStoryboard.init(name: "Map", bundle: nil)
            let mapVC = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            
            mapVC.resultFood = self.resultFood
            
            // 태그 변경
            self.stopButton.tag = 0
            
            self.present(mapVC, animated: true)
        }
    }
    
    
    
    @IBAction func homeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
