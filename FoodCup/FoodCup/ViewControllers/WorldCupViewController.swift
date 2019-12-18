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
enum Tournament: Int {
    case roundOfSixteen = 16
    case quarterfinal = 8
    case semifinal = 4
    case final = 2
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
    var topFoodImageList = [String]()
    var bottomFoodImageList = [String]()
    var selectedList = [String]()
//    var topNum = 14
//    var bottomNum = 15
    var tournament: Tournament = .roundOfSixteen // 현재 토너먼트가 몇강인지 나타내 주는 변수
    
    
    
    // MARK:- Constants
    let userDefaults = UserDefaults.standard
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewInit()
    }
    
    
    
    // 첫 뷰 세팅
    func viewInit() {
        self.bgImageView.image = UIImage(named: "roundOf16")
        
        // 이미지 비스듬하게 보이게 하기
        self.topImageView.transform = CGAffineTransform(rotationAngle: 0.1)
        self.topStickerView.transform = CGAffineTransform(rotationAngle: 0.7)
        
        self.bottomImageView.transform = CGAffineTransform(rotationAngle: -0.1)
        self.bottomStickerView.transform = CGAffineTransform(rotationAngle: -0.7)
        
        self.allFood.shuffle()
        
        let tournamentValue = tournament.rawValue
        topFoodImageList = Array(allFood[0..<tournamentValue/2])
        bottomFoodImageList = Array(allFood[tournamentValue/2..<tournamentValue])
        
        self.drawImage()
        self.viewTapSet()
    }
    
    
    
    // 음식 이미지 그리기 메소드
    func drawImage() {
        self.topImageView.image = UIImage(named: topFoodImageList.last!)
        self.bottomImageView.image = UIImage(named: bottomFoodImageList.last!)
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
        var selectedFood: String?
        if tapGestureRecognizer.view!.tag == 1 { // topView 선택시
            selectedFood = topFoodImageList.popLast()
            bottomFoodImageList.removeLast()
            
            self.topImageView.expand(into: self.topView, finished: nil)
        } else { // bottomView 선택시
            topFoodImageList.removeLast()
            selectedFood = bottomFoodImageList.popLast()
    
            self.bottomImageView.expand(into: self.bottomView, finished: nil)
        }
        
        selectedList.append(selectedFood!)
        
        foodCupMatching()
    }
    
    
    
    func foodCupMatching() {
        if topFoodImageList.count == 0 && bottomFoodImageList.count == 0 {
            switch tournament {
                case .roundOfSixteen:
                    tournament = .quarterfinal
                    bgImageView.image = UIImage(named: "roundOf8")
                    break
                case .quarterfinal:
                    self.tournament = .semifinal
                    self.bgImageView.image = UIImage(named: "roundOf4")
                    break
                case .semifinal:
                    self.tournament = .final
                    self.bgImageView.image = UIImage(named: "roundOfFinal")
                    break
                case .final:
                    finalMatching()
                    return
            }
            
            selectedList.shuffle()
            
            let tournamentValue = tournament.rawValue
            topFoodImageList = Array(selectedList[0..<tournamentValue/2])
            bottomFoodImageList = Array(selectedList[tournamentValue/2..<tournamentValue])
            selectedList.removeAll()
        }
        
        drawImage()
    }
    
    
    
    func finalMatching() {
        let storyboard = UIStoryboard.init(name: "Result", bundle: nil)
        guard let resultVC = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            return
        }
        
        resultVC.modalPresentationStyle = .fullScreen
        
        let selectedFood = selectedList.last
        
        resultVC.result = selectedFood
        self.userDefaults.setValue(selectedFood, forKey: "result")

        self.present(resultVC, animated: false)
    }
    
    
    
    // MARK:- Actions
    @IBAction func stopBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
