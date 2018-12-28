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
    
    
    
    // MARK:- Variable
    var result: String?
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bgImageView.image = UIImage(named: "back_result")
        
        self.resultImageView.image = UIImage(named: self.result!)
    }

    
    
    // MARK:- Actions
    @IBAction func searchBtnPressed(_ sender: Any) {
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        
        mapVC.resultFood = self.result!
        
        present(mapVC, animated: true)
    }
    
}
