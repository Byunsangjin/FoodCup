//
//  Utils.swift
//  FoodCup
//
//  Created by Byunsangjin on 26/12/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit
import PopupDialog

// 알람 메세지
extension UIViewController {
    // 메세지
    func okAlert(_ title: String?, _ message: String?, completion: (()->Void)? = nil) {
        // 메인 스레드에서 실행되도록
        DispatchQueue.main.async {
            let alert = PopupDialog(title: title, message: message, image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 200, tapGestureDismissal: true, panGestureDismissal: false, hideStatusBar: false, completion: {
                completion?()
            })
            
            alert.addButton(PopupDialogButton(title: "확인", action: {
                completion?()
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    
    
    func confirmAlert(_ title: String?, _ message: String?, completion: (()->Void)? = nil) {
        // 메인 스레드에서 실행되도록
        DispatchQueue.main.async {
            
            let alert = PopupDialog(title: title, message: message, image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: false, hideStatusBar: false, completion: nil)
            
            alert.addButton(PopupDialogButton(title: "확인", action: {
                completion?()
            }))
            alert.addButton(PopupDialogButton(title: "취소", action: nil))
            
            self.present(alert, animated: true)
        }
    }
}
