//
//  LoginViewController.swift
//  FoodCup
//
//  Created by Byunsangjin on 31/12/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    // MARK:- Outlets
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var pwTextField: UITextField!
    
    @IBOutlet var bgImageView: UIImageView!
    
    
    
    // MARK:- Constants
    let ud = UserDefaults.standard
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.bgImageView.image = UIImage(named: "loginBackground.png")
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        self.view.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(swipe)))
    }
    
    
    
    // 텍스트 필드 초기화
    func initTextField() {
        self.emailTextField.text = ""
        self.pwTextField.text = ""
    }
    
    
    
    @objc func tap() {
        self.view.endEditing(true)
    }
    
    @objc func swipe() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK:- Actions
    @IBAction func loginBtnPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.pwTextField.text!) { (user, error) in
            if error != nil { // 에러가 있을 때
                if error?._code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    self.okAlert(nil, "이미 동일한 이메일이 있습니다.")
                } else if error?._code == AuthErrorCode.invalidEmail.rawValue {
                    self.okAlert(nil, "이메일을 정확히 입력해 주세요")
                } else if error?._code == AuthErrorCode.wrongPassword.rawValue {
                    self.okAlert(nil, "비밀번호는 정확히 입력해주세요.")
                } else if error?._code == AuthErrorCode.userNotFound.rawValue{
                    self.okAlert("가입되지 않은 계정입니다.", nil)
                } else {
                    self.okAlert(error?.localizedDescription, nil)
                }
            } else { // 에러가 없을 때
                print("로그인 성공")
                
                self.ud.setValue(true, forKey: "isSignIn")
                
                self.delegate.getFoodInfo() {
                    let storyboard = UIStoryboard.init(name: "FoodList", bundle: nil)
                    let foodListVC = storyboard.instantiateViewController(withIdentifier: "FoodListViewController")
                    
                    foodListVC.modalPresentationStyle = .fullScreen
                    self.present(foodListVC, animated: true, completion: nil)
                }
                
                // 로그인 성공시 텍스트필드 초기화
                self.initTextField()
            }
        }
    }
    
    
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "SignUp", bundle: nil)
        let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
        signUpVC.modalPresentationStyle = .fullScreen
        self.initTextField()
        
        self.present(signUpVC, animated: true)
    }
    
}
