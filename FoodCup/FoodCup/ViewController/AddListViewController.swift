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
import Firebase

// 좌표
class MyCoordinate {
    var latitude: String?
    var longitude: String?
}



class AddListViewController: UIViewController, MTMapViewDelegate, CLLocationManagerDelegate {
    // MARK:- Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var mapView: UIView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var mapButton: UIButton!
    
    
    
    // MARK:- Variables
    lazy var daumMapView: MTMapView = MTMapView(frame: CGRect(x: 0, y: 0, width: self.mapView.frame.width, height: self.mapView.frame.height)) // 다음 맵 뷰
    var mapList = [MapVO]() // REST API를 이용해 받은 주변 정보
    var foodContent: FoodContent = FoodContent()
    
    var searchWord: String? = "" // 검색어
    var uid: String?
    
    
    
    // MARK:- Constants
    let dataRef = Database.database().reference()
    let storageRef = Storage.storage().reference()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    let mapManager = DaumMapManager()
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewSet()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.mapViewSet()
        
        self.contentInfoSet()
        
        self.mapManager.showMarker(daumMapView: self.daumMapView, foodContent: self.foodContent)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        // 좌표 초기화
        self.delegate.lng = 0
        self.delegate.lat = 0
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToSearch" {
            let searchVC = segue.destination as! SearchViewController
            searchVC.searchWord = self.searchWord
        }
    }
    
    
    
    // 초기 뷰 설정
    func viewSet() {
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker))) // 이미지 탭 제스쳐 추가
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(save)) // 내비게이션 바 아이템 추가
        
        // 임시코드
        self.uid = Auth.auth().currentUser?.uid
    }
    
    
    
    // 맵뷰 세팅 메소드
    func mapViewSet() {
        self.daumMapView.delegate = self
        self.daumMapView.baseMapType = .standard
        
        if self.delegate.lng != 0 {
            self.mapView.addSubview(self.daumMapView)
        }
    }
    
    
    
    // 맵에 관련 정보 설정
    func contentInfoSet() {
        self.foodContent.name = self.delegate.name!
        self.foodContent.address = self.delegate.address!
        self.foodContent.lng = self.delegate.lng!
        self.foodContent.lat = self.delegate.lat!
    }
    
    
    
    // 글에 관한 정보 설정 및 리스트에 추가
    func contentSet() {
        self.foodContent.image = self.imageView.image!
        self.foodContent.text = self.textView.text!
        self.delegate.foodList.append(self.foodContent)
    }
    
    
    
    // 저장버튼 눌렀을 때 동작 메소드
    @objc func save() {
        self.confirmAlert("저장하시겠습니까?", nil) {
            var image = UIImage()
            image = self.imageView.image!
            
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
                    self.dataRef.child("users").child(self.uid!).childByAutoId().setValue(["imgUrl": url!.absoluteString, "text": self.textView.text!, "name": self.delegate.name ,"address": self.delegate.address!], withCompletionBlock: { (erro, ref) in
                        print("데이터 저장 성공")
                    })
                }
            }
            
            // foodList에 정보 추가
            self.contentSet()
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    // MARK:- Actions
    @IBAction func mapBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "음식점 검색", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "예) 돈카2014"
        }
        
        alert.addAction(UIAlertAction(title: "검색", style: .default, handler: { (_) in
            self.searchWord = alert.textFields?.last?.text!
            self.performSegue(withIdentifier: "SegueToSearch", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
    }
}



extension AddListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        //picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true)
        print("Picker")
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // self.imageSelected = true // 이미지를 선택 했다면 true
        
        self.imageView.image = (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
        
        self.dismiss(animated: true, completion: nil)
    }
}


