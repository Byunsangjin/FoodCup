//
//  WorldCupViewController.swift
//  FoodCup
//
//  Created by Byunsangjin on 27/12/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit


// 토너먼트 몇강인지
enum Tournament {
    case quarterfinal
    case semifinal
    case final
}



class WorldCupViewController: UIViewController {
    // MARK:- Outlets
    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var bottomImageView: UIImageView!
    @IBOutlet var bgImageView: UIImageView!
    
    
    
    // MARK:- Variables
    var foodList = ["족발", "보쌈", "냉면", "돈까스", "된장찌개", "짜장면", "치킨", "햄버거"]
    var topNum = 6
    var bottomNum = 7
    var tournament: Tournament = Tournament.quarterfinal // 현재 토너먼트가 몇강인지 나타내 주는 변수
    
    
    
    // MARK:- Constants
    let userDefaults = UserDefaults.standard
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewInit()
    }
    
    
    
    // 첫 뷰 세팅
    func viewInit() {
        // 배경 이미지 설정
        self.bgImageView.image = UIImage(named: "back_quarter_final")
        
        // 음식 String List 섞기
        self.foodList.shuffle()
        
        self.drawImage()
        
        self.imageTapSet()
    }
    
    
    
    // 음식 이미지 그리기 메소드
    func drawImage() {
        self.topImageView.image = UIImage(named: foodList[topNum])
        self.bottomImageView.image = UIImage(named: foodList[bottomNum])
    }
    
    
    
    // 이미지 탭 허용 설정 메소드
    func imageTapSet() {
        let tapTopImageView = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.topImageView.isUserInteractionEnabled = true
        self.topImageView.addGestureRecognizer(tapTopImageView)
        
        let tapBottomImageView = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.bottomImageView.isUserInteractionEnabled = true
        self.bottomImageView.addGestureRecognizer(tapBottomImageView)
    }
    
    
    
    // 이미지를 탭했을 때 동작하는 메소드
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if (tapGestureRecognizer.view?.tag)! == 1 { // topImageView 선택시
            foodList.remove(at: bottomNum)
        } else { // bottomImageView 선택시
            foodList.remove(at: topNum)
        }
        
        switch tournament {
            case .quarterfinal:
                quarterfinal()
                break
            case .semifinal:
                semifinal()
                break
            case .final:
                final()
                break
        }
    }
    
    
    
    // 8강
    func quarterfinal() {
        if topNum == 0 {
            self.tournament = .semifinal
            
            // 음식 String List 섞기
            self.foodList.shuffle()
            
            // 4강 시작
            bottomNum = foodList.count - 1
            topNum = bottomNum - 1
            
            // 배경 사진 4강으로 바꾸기
            self.bgImageView.image = UIImage(named: "back_semi_final")
            drawImage()
            
            return
        }
        
        // 다음 비교할 사진의 배열 번호
        topNum -= 2
        bottomNum -= 2
        
        drawImage()
    }
    
    
    
    // 4강
    func semifinal() {
        if topNum == 0 {
            self.tournament = .final
            
            // 음식 String List 섞기
            self.foodList.shuffle()
            
            // 결승 시작
            bottomNum = foodList.count - 1
            topNum = bottomNum - 1
            
            // 배경 사진 결승으로 바꾸기
            self.bgImageView.image = UIImage(named: "back_final")
            
            drawImage()
            
            return
        }
        
        // 다음 비교할 사진의 배열 번호
        topNum -= 2
        bottomNum -= 2
        
        drawImage()
    }
    
    
    
    // 결승
    func final() {
        guard let resultVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            print("에러")
            return
        }
        
        resultVC.result = foodList[0]
        self.userDefaults.setValue(foodList[0], forKey: "result")

        self.present(resultVC, animated: false)
        
        self.alert("결정 성공", self.foodList[0])
    }
    
    
    
    
    // MARK:- Actions
    @IBAction func stopBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
