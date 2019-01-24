//
//  FoodListViewController.swift
//  FoodCup
//
//  Created by Byunsangjin on 31/12/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit
import Firebase
import PopupDialog
import CircleMenu

class FoodListViewController: UIViewController {
    // MARK:- Outlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var plusButton: CircleMenu!
    
    
    
    // MARK:- Variables
    
    
    
    // MARK:- Constants
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let storageRef = Storage.storage().reference()
    let dataRef = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.plusButton.buttonsCount = 8
        self.plusButton.delegate = self
        self.plusButton.distance = Float(self.view.frame.width / 4)
        self.plusButton.duration = 1
    }
   
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    
    
    // 저장버튼 눌렀을 때
    func addBtnPressed() {
        let foodContent: FoodContent = self.delegate.foodContent
        self.delegate.foodContent = FoodContent() // 델리게이트 foodContent 초기화
        
        // foodList에 정보 추가
        self.delegate.foodList.append(foodContent)
        self.collectionView.reloadData()
        
        var image = UIImage()
        image = foodContent.image!
        
        let data: Data = image.jpegData(compressionQuality: 0.1)! // 이미지 데이터로 변환
        let spaceRef = self.storageRef.child("users").child(self.uid!).child(UUID().uuidString) // 저장소에 저장
        
        spaceRef.putData(data, metadata: nil) { (metadata, error) in
            guard error == nil else { // 에러가 발생 했을 때
                print("putData error : \(String(describing: error))")
                return
            }
            
            // 다운로드 url에 접근한다.
            spaceRef.downloadURL { (url, error) in
                guard error == nil else { // 에러가 발생 했을 때
                    print("download error \(String(describing: error?.localizedDescription))")
                    return
                }
                
                // 데이터 베이스에 접근해서 이름 값과 이미지 다운로드 url을 넣어준다
                self.dataRef.child("users").child(self.uid!).childByAutoId().setValue(["imgUrl": url!.absoluteString, "text": foodContent.text, "name": foodContent.name ,"address": foodContent.address!, "lng": foodContent.lng, "lat": foodContent.lat, "date": Date().string() ], withCompletionBlock: { (erro, ref) in
                    print("데이터 저장 성공")
                })
            }
        }
    }
    
    
    
    // 사이드 버튼 만들기
    func createSideButton(button: UIButton, imageName: String) {
        button.setImage(UIImage(named: imageName), for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.frame.size.width = self.view.frame.width / 10
        button.frame.size.height = self.view.frame.width / 10
        button.layer.cornerRadius = button.frame.size.height / 2
    }
}



extension FoodListViewController:  UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    // collectionView 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.delegate.foodList.count)
        return delegate.foodList.count
    }
    
    
    
    // collectionView cell 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        
        cell.imageView.image = delegate.foodList[indexPath.row].image
        
        return cell
    }
    
    
    
    // collectionView size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width - 20) / 3
        
        return CGSize(width: width, height: width)
    }
    
    
    
    // collectionView 선택 시
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "FoodList", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        detailVC.foodContent = self.delegate.foodList[indexPath.row]
        
        self.present(detailVC, animated: true)
    }
}


extension FoodListViewController: CircleMenuDelegate {
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        if atIndex == 0 || atIndex == 1 || atIndex == 2 || atIndex == 3 || atIndex == 7 || atIndex == 8 {
            button.backgroundColor = UIColor.clear
        } else if atIndex == 4 {
            self.createSideButton(button: button, imageName: "setting")
        } else if atIndex == 5 {
            self.createSideButton(button: button, imageName: "add")
        } else if atIndex == 6 {
            self.createSideButton(button: button, imageName: "exit")
        }
    }
    
    
    
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        if atIndex == 4 {
            let storyboard = UIStoryboard.init(name: "FoodList", bundle: nil)
            let licenseVC = storyboard.instantiateViewController(withIdentifier: "_LisenceViewController") as! UINavigationController
            self.present(licenseVC, animated: true)
        } else if atIndex == 5 {
            let storyboard = UIStoryboard.init(name: "FoodList", bundle: nil)
            let addListVC = storyboard.instantiateViewController(withIdentifier: "AddAlertViewController") as! AddAlertViewController
            let alert = PopupDialog(viewController: addListVC, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 340, tapGestureDismissal: false, panGestureDismissal: false, hideStatusBar: false)
            
            alert.addButton(PopupDialogButton(title: "저장") {
                self.addBtnPressed()
            })
            alert.addButton(PopupDialogButton(title: "취소", action: nil))
            
            present(alert, animated: true)
        } else if atIndex == 6 {
            self.confirmAlert("정말 로그아웃하시겠습니까?", nil) {
                try! Auth.auth().signOut()
                UserDefaults.standard.setValue(false, forKey: "isSignIn")
                self.delegate.foodList.removeAll()
                self.dismiss(animated: true) {
                    print("로그아웃")
                }
            }
        }
    }
}
