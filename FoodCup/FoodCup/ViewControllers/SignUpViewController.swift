//
//  SignUpViewController.swift
//  FoodCup
//
//  Created by Byunsangjin on 31/12/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    // MARK:- Outlets
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var pwTextField: UITextField!
    @IBOutlet var rePwTextField: UITextField!
    
    @IBOutlet var signUpBtn: UIImageView!
    @IBOutlet var bgImageView: UIImageView!
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        self.signUpBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpBtnPressed)))
        self.bgImageView.image = UIImage(named: "signUpBackground.png")
    }
    
    
    
    // 계정 생성 메소드
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.pwTextField.text!) { (result, error) in
            if error == nil { // 에러가 없다면
                // 사용자 이름을 넣어준다.
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = self.nameTextField.text!
                changeRequest?.commitChanges(completion: nil)
                
                try! Auth.auth().signOut()
                
                self.okAlert(nil, "회원가입에 성공 하셨습니다.") {
                    self.dismiss(animated: true, completion: nil)
                }
            } else { // 에러가 있다면
                if error?._code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    self.okAlert(nil, "이미 동일한 이메일이 있습니다.")
                } else if error?._code == AuthErrorCode.invalidEmail.rawValue {
                    self.okAlert(nil, "이메일을 정확히 입력해 주세요")
                } else if error?._code == AuthErrorCode.weakPassword.rawValue {
                    self.okAlert(nil, "비밀번호는 6자리 이상이어야 합니다.")
                } else {
                    print("계정 생성 실패 : \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
    
    
    
    @objc func tap() {
        self.view.endEditing(true)
    }
    
    
    
    @objc func signUpBtnPressed() {
        print("test")
        if self.emailTextField.text!.isEmpty || self.nameTextField.text!.isEmpty || self.pwTextField.text!.isEmpty { // 텍스트 필드에 입력하지 않은 값이 있으면
            self.okAlert(nil, "공백을 입력하세요.")
        } else if self.pwTextField.text != self.rePwTextField.text { // 패스워드가 다르면
            self.okAlert(nil, "패스워드를 확인해주세요.")
        } else {
            self.createUser(email: self.emailTextField.text!, password: self.pwTextField.text!)
        }
    }
    
    
    
    // MARK:- Actions
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
