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
                self.okAlert("로그인 실패", (error?.localizedDescription)!)
            } else { // 에러가 없을 때
                print("로그인 성공")
                
                self.ud.setValue(true, forKey: "isSignIn")
                
                self.delegate.getFoodInfo() {
                    let storyboard = UIStoryboard.init(name: "FoodList", bundle: nil)
                    let foodListVC = storyboard.instantiateViewController(withIdentifier: "FoodListViewController")
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
        
        self.initTextField()
        
        self.present(signUpVC, animated: true)
    }
    
}
