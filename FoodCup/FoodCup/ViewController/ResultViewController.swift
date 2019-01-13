//
//  ResultViewController.swift
//  FoodCup
//
//  Created by Byunsangjin on 27/12/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    // MARK:- Outlets
    @IBOutlet var bgImageView: UIImageView!
    @IBOutlet var resultImageView: UIImageView!
    
    @IBOutlet var searchBtnImageView: UIImageView!
    
    
    // MARK:- Variable
    var result: String?
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bgImageView.image = UIImage(named: "resultBackground.png")
        
        self.resultImageView.image = UIImage(named: self.result!)
        
        searchBtnImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchBtnPressed)))
    }
    
    
    
    @objc func searchBtnPressed() {
        let storyboard = UIStoryboard.init(name: "Map", bundle: nil)
        let mapVC = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        
        mapVC.resultFood = self.result!
        
        present(mapVC, animated: true)
    }
}
