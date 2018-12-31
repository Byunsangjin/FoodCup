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
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var pwTextField: UITextField!
    
    
    

    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK:- Actions
    @IBAction func loginBtnPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.pwTextField.text!) { (user, error) in
            if error != nil { // 에러가 있을 때
                self.alert("로그인 실패", (error?.localizedDescription)!)
            } else { // 에러가 없을 때
                let storyboard = UIStoryboard.init(name: "FoodList", bundle: nil)
                let foodListVC = storyboard.instantiateViewController(withIdentifier: "FoodListViewController") as! FoodListViewController
                
                self.present(foodListVC, animated: true)
            }
        }
    }
    
    

    @IBAction func signUpBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "SignUp", bundle: nil)
        let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
        self.present(signUpVC, animated: true)
    }
}
