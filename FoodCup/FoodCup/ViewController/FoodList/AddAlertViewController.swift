//
//  AddContentViewController.swift
//  FoodCup
//
//  Created by Byunsangjin on 14/01/2019.
//  Copyright © 2019 Byunsangjin. All rights reserved.
//

import UIKit
import UIKit
import CoreLocation
import Alamofire
import AlamofireObjectMapper
import Firebase
import PopupDialog

class AddAlertViewController: UIViewController {
    // MARK:- Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var searchBtn: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    
    
    // MARK:- Variables
    var restaurantTitle = ""
    
    
    
    // MARK:- Constants
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.layer.borderWidth = 1.0
        self.textView.layer.borderColor = UIColor.darkGray.cgColor
        
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker)))
        self.searchBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchBtnPressed)))
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.titleLabel.text = self.delegate.foodContent.name
        self.delegate.foodContent.image = self.imageView.image
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        self.delegate.foodContent.text = self.textView.text
    }
    
    
    
    @objc func searchBtnPressed() {
        let storyboard = UIStoryboard.init(name: "FoodList", bundle: nil)
        let mapVC = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        self.present(mapVC, animated: true)
    }
}



extension AddAlertViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imageView.image = (info[UIImagePickerController.InfoKey.editedImage] as! UIImage)
        
        self.dismiss(animated: true, completion: nil)
    }
}
