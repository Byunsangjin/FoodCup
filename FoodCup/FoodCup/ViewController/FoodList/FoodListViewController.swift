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

class FoodListViewController: UIViewController {
    // MARK:- Outlets
    @IBOutlet var collectionView: UICollectionView!
    
    
    
    // MARK:- Variables
    
    
    
    // MARK:- Constants
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let storageRef = Storage.storage().reference()
    let dataRef = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    
    
    // 로그아웃 버튼 클릭시
    @IBAction func signOutBtnPressed(_ sender: Any) {
        try! Auth.auth().signOut()
        UserDefaults.standard.setValue(false, forKey: "isSignIn")
        self.delegate.foodList.removeAll()
        self.dismiss(animated: true) {
            print("로그아웃")
        }
    }
    
    
    
    // + 버튼 클릭시
    @IBAction func plusBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "FoodList", bundle: nil)
        let addListVC = storyboard.instantiateViewController(withIdentifier: "AddAlertViewController") as! AddAlertViewController
        let alert = PopupDialog(viewController: addListVC, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 340, tapGestureDismissal: false, panGestureDismissal: false, hideStatusBar: false)
        
        alert.addButton(PopupDialogButton(title: "저장") {
            self.addBtnPressed()
        })
        alert.addButton(PopupDialogButton(title: "취소", action: nil))
        
        present(alert, animated: true)
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
                self.dataRef.child("users").child(self.uid!).childByAutoId().setValue(["imgUrl": url!.absoluteString, "text": foodContent.text, "name": foodContent.name ,"address": foodContent.address!, "lng": foodContent.lng, "lat": foodContent.lat], withCompletionBlock: { (erro, ref) in
                    print("데이터 저장 성공")
                })
            }
        }
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
        let storyboard = UIStoryboard.init(name: "Detail", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        detailVC.foodContent = self.delegate.foodList[indexPath.row]
        
        self.present(detailVC, animated: true)
    }
}


