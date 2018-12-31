//
//  FoodListViewController.swift
//  FoodCup
//
//  Created by Byunsangjin on 31/12/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit

class FoodListViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK:- Outlets
    
    
    
    // MARK:- Variables
    var foodList = ["족발", "보쌈", "냉면", "돈까스", "된장찌개", "짜장면", "치킨", "햄버거"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        // 내비게이션 바 숨기기
        // self.navigationController?.navigationBar.isHidden = true
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        
        cell.imageView.image = UIImage(named: foodList[indexPath.row % foodList.count])
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width / 3
        
        return CGSize(width: width, height: width)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Detail", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        detailVC.foodName = self.foodList[indexPath.row % self.foodList.count]
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        // self.present(detailVC, animated: true)
        
        
    }
    
}


class CollectionCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
}
