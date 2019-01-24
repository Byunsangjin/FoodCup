//
//  AppDelegate.swift
//  FoodCup
//
//  Created by Byunsangjin on 26/12/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit
import Firebase
import SnapKit
import Alamofire
import AlamofireImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK:- Variables
    var window: UIWindow?
    var themeColor: String?
    var foodContent = FoodContent()
    var foodList: [FoodContent] = []
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        
        
        // 테마 색상 불러오기
        self.themeColor = RemoteConfig.remoteConfig()["splash_background"].stringValue
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    // statusBar 색상 설정
    func statusBarSet(view: UIView) {
        // statusBar 설정
        let statusBar = UIView()
        view.addSubview(statusBar)
        
        statusBar.snp.makeConstraints { (make) in
            make.right.left.equalTo(view)
            make.height.equalTo(UIApplication.shared.statusBarFrame.height)
        }
        
        // 배경 색상 설정
        statusBar.backgroundColor = UIColor(hexString: self.themeColor!)
    }
    
    
    
    // DB에서 음식 정보 받아오기
    func getFoodInfo(completion: (()->Void)? = nil) {
        let uid = Auth.auth().currentUser?.uid
        let dataRef = Database.database().reference()
        dataRef.child("users").child(uid!).queryOrdered(byChild: "date") .observeSingleEvent(of: .value) { (dataSnapshot) in
            // 데이터 순회하며 유저 정보 배열 검색
            var count = dataSnapshot.childrenCount
            if count == 0 {
                completion?()
            }
            
            for item in dataSnapshot.children {
                let foodContent = FoodContent()
                let fchild = item as! DataSnapshot
                
                foodContent.setValuesForKeys(fchild.value as! [String : Any])
                
                Alamofire.request(foodContent.imgUrl!).responseImage { response in
                    if let image = response.result.value {
                        foodContent.image = image
                    }
                    
                    self.foodList.append(foodContent)                    
                    
                    count = count - 1
                    if count == 0 {
                        self.foodList.sort(by: {$0.date! < $1.date!})
                        
                        completion?()
                    }
                }
            }
        }
    }
}

