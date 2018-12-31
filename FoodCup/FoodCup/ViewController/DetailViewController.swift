//
//  DetailViewController.swift
//  FoodCup
//
//  Created by Byunsangjin on 31/12/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK:- Outlets
    @IBOutlet var imageView: UIImageView!
    
    
    
    // MARK:- Variables
    var foodName: String?
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // 내비게이션 바 나타내기
        self.navigationController?.navigationBar.isHidden = false
        
        self.imageView.image = UIImage(named: foodName!)
    }
}
