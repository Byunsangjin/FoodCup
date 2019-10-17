//
//  WorldCupViewController.swift
//  FoodCup
//
//  Created by Byunsangjin on 27/12/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit
import DCAnimationKit

// 토너먼트 몇강인지
enum Tournament {
    case roundOfSixteen
    case quarterfinal
    case semifinal
    case final
}



class WorldCupViewController: UIViewController {
    // MARK:- Outlets
    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var bottomImageView: UIImageView!
    @IBOutlet var bgImageView: UIImageView!
    
    @IBOutlet var topStickerView: UIView!
    @IBOutlet var bottomStickerView: UIView!
    
    @IBOutlet var topView: UIView!
    @IBOutlet var bottomView: UIView!
    
    
    
    // MARK:- Variables
    var allFood = ["간장게장", "김밥", "김치찌개", "냉면", "닭발", "돈까스", "떡볶이", "보쌈", "부대찌개", "삼겹살", "순대", "순대국", "양꼬치", "족발", "짬뽕", "치킨", "탕수육", "파스타"]
    var foodList = [String]()
    var topNum = 14
    var bottomNum = 15
    var tournament: Tournament = Tournament.roundOfSixteen // 현재 토너먼트가 몇강인지 나타내 주는 변수
    
    
    
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
        self.bgImageView.image = UIImage(named: "roundOf16")
        
        // 이미지 비스듬하게 보이게 하기
        self.topImageView.transform = CGAffineTransform(rotationAngle: 0.1)
        self.topStickerView.transform = CGAffineTransform(rotationAngle: 0.7)
        
        self.bottomImageView.transform = CGAffineTransform(rotationAngle: -0.1)
        self.bottomStickerView.transform = CGAffineTransform(rotationAngle: -0.7)
        
        // 음식 String List 섞기
        self.allFood.shuffle()
        
        var i = 0
        for _ in 0..<16 {
            self.foodList.append(allFood[i])
            i = i + 1
        }
        
        self.drawImage()
        
        self.viewTapSet()
    }
    
    
    
    // 음식 이미지 그리기 메소드
    func drawImage() {
        self.topImageView.image = UIImage(named: foodList[topNum])
        self.bottomImageView.image = UIImage(named: foodList[bottomNum])
    }
    
    
    
    // 이미지 탭 허용 설정 메소드
    func viewTapSet() {
        let tapTopGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(tapGestureRecognizer:)))
        let tapBottomGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(tapGestureRecognizer:)))
        
        self.topView.addGestureRecognizer(tapTopGesture)
        self.bottomView.addGestureRecognizer(tapBottomGesture)
    }
    
    
    
    // 이미지를 탭했을 때 동작하는 메소드
    @objc func viewTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print(tapGestureRecognizer.view!.tag)
        
        if tapGestureRecognizer.view!.tag == 1 { // topView 선택시
            foodList.remove(at: bottomNum)
            
            self.topView.expand(into: self.view, finished: {
                print("topTap")
            })
        } else { // bottomView 선택시
            foodList.remove(at: topNum)
            
            self.bottomView.expand(into: self.view, finished: {
                print("bottomTap")
            })
        }
        
        switch tournament {
            case .roundOfSixteen:
                roundOfSixteen()
                break
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
    
    
    
    //16강
    func roundOfSixteen() {
        if topNum == 0 {
            self.tournament = .quarterfinal
            
            // 음식 String List 섞기
            self.foodList.shuffle()
            
            // 4강 시작
            bottomNum = foodList.count - 1
            topNum = bottomNum - 1
            
            // 배경 사진 4강으로 바꾸기
            self.bgImageView.image = UIImage(named: "roundOf8")
            drawImage()
            
            return
        }
        
        // 다음 비교할 사진의 배열 번호
        topNum -= 2
        bottomNum -= 2
        
        drawImage()
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
            self.bgImageView.image = UIImage(named: "roundOf4")
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
            self.bgImageView.image = UIImage(named: "roundOfFinal")
            
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
        let storyboard = UIStoryboard.init(name: "Result", bundle: nil)
        guard let resultVC = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            print("에러")
            return
        }
        
        resultVC.modalPresentationStyle = .fullScreen
        resultVC.result = foodList[0]
        self.userDefaults.setValue(foodList[0], forKey: "result")

        self.present(resultVC, animated: false)
        
        self.okAlert("결정 성공", self.foodList[0])
    }
    
    
    
    // MARK:- Actions
    @IBAction func stopBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
