//
//  ViewController.swift
//  FoodCup
//
//  Created by Byunsangjin on 26/12/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation


class SplashViewController: UIViewController {
    // MARK:- Outlets
    @IBOutlet var bgImageView: UIImageView!
    
    
    
    
    // MARK:- Variables
    var remoteConfig: RemoteConfig!
    
    
    
    // MARK:- Constants
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let ud = UserDefaults.standard
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경 이미지 설정
        self.bgImageView.image = UIImage(named: "loginBackground.png")
        
        // 우선 원격 구성 개체 인스턴스를 가져오고 캐시를 빈번하게 새로고칠 수 있도록 개발자 모드를 사용 설정합니다.
        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.configSettings = RemoteConfigSettings(developerModeEnabled: true)
        
        // plist 파일에서 인앱 기본값을 설정합니다.
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        // 원격 구성 호출 하는 메소드
        remoteConfig.fetch(withExpirationDuration: TimeInterval(0)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activateFetched()
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
            self.displayWelcome()
        }
    }
    
    
    
    func displayWelcome() {
        let color = self.delegate.themeColor
        let caps = remoteConfig["splash_message_caps"].boolValue
        let message = remoteConfig["splash_message"].stringValue
        
        print(caps)
        if caps { // 서버 점검 중 이라면 알람띄우고 앱 종료
            self.okAlert("공지사항", message) {
                exit(0)
            }
        } else { // 그렇지 않다면 로그인으로 이동
            print("displayWelcome")
            if ud.bool(forKey: "isSignIn") { // 로그인 상태라면 데이터를 받고 이동
                self.delegate.getFoodInfo() {
                    self.presentVC()
                }
            } else { // 로그인 상태가 아니라면 화면만 이동
                self.presentVC()
            }
        }
        
        self.view.backgroundColor = UIColor(hexString: color!)
    }
    
    
    
    func presentVC() {
        let storyborad = UIStoryboard.init(name: "Main", bundle: nil)
        let mainVC = storyborad.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        self.present(mainVC, animated: true)
    }
}



// String으로 Color를 지정
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

