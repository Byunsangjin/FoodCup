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
    @IBOutlet var collectionView: UICollectionView!
    
    
    
    // MARK:- Variables
    
    
    
    // MARK:- Constants
    let delegate = UIApplication.shared.delegate as! AppDelegate
    

    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    
    
    // collectionView 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.delegate.foodList.count)
        return delegate.foodList.count
    }
    
    
    
    // collectionView cell 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        
        cell.imageView.image = delegate.foodList[indexPath.row].image
        
        return cell
    }
    
    
    
    // collectionView size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width / 3 - 5
        
        return CGSize(width: width, height: width)
    }
    
    
    
    // collectionView 선택 시
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Detail", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        detailVC.foodContent = self.delegate.foodList[indexPath.row]
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    
    // MARK:- Actions
    @IBAction func addListBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "AddList", bundle: nil)
        let addListVC = storyboard.instantiateViewController(withIdentifier: "AddListViewController") as! AddListViewController
        
        self.navigationController?.pushViewController(addListVC, animated: true)
    }
    
    
    
}


class CollectionCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
}
