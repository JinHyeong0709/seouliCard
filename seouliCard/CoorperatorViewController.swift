//
//  CoorperatorViewController.swift
//  seouliCard
//
//  Created by 김진형 on 11/02/2019.
//  Copyright © 2019 JinHyeongKim. All rights reserved.
//

import UIKit

class CoorperatorViewController: UIViewController {

    //MARK: - Property
    @IBOutlet weak var selectCategoryButton: UISegmentedControl!
    @IBOutlet weak var collectionTableView: UICollectionView!
    
    let filteringObject = FilteringOjbect()
    let imageKeyMapping = ImageKeyMapping()
    
    @IBAction func changeCategory(_ sender: UISegmentedControl) {
        collectionTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let listVC = segue.destination as? CoorpListViewController {
            if let cell = sender as? CoorperatorCollectionViewCell {
                if let indexPath = collectionTableView.indexPath(for: cell) {
                    if self.selectCategoryButton.selectedSegmentIndex == 0 {
                        listVC.receiveCategoryFilterObject = filteringObject.categoryList[indexPath.row]
                        listVC.dataTypeFlag = true
                    } else {
                        listVC.receiveLocationFilterObject = filteringObject.locationList[indexPath.item]
                        listVC.dataTypeFlag = false
                    }
                }
            }
        }
    }
}


extension CoorperatorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch selectCategoryButton.selectedSegmentIndex {
        case 0:
            return filteringObject.categoryList.count
        case 1:
            return filteringObject.locationList.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellId = selectCategoryButton.selectedSegmentIndex == 0 ? "categoryCell" : "locationCell"
        
        let cell = collectionTableView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CoorperatorCollectionViewCell
        
        if selectCategoryButton.selectedSegmentIndex == 0 {
            cell.categoryLabel.text = filteringObject.categoryList[indexPath.item]
            let target = filteringObject.categoryList[indexPath.item]
            let imageName = imageKeyMapping.imageDictionary[target] ?? ""
            
            cell.filteringImageView.image = UIImage(named: imageName)
        } else {
            cell.locationLabel.text = filteringObject.locationList[indexPath.item]
            cell.layer.borderWidth = 1.5
            cell.layer.cornerRadius = 20.0
            cell.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        return cell
    }
}

extension CoorperatorViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        layout.sectionInset.left = 10.0
        layout.sectionInset.right = 10.0
        layout.minimumLineSpacing = 15.0
        let width = (collectionTableView.bounds.width - (layout.sectionInset.left + layout.sectionInset.right + layout.minimumLineSpacing)) / 3.5
        
        if selectCategoryButton.selectedSegmentIndex == 0 {
            return CGSize(width: width, height: width * 1.2)
        } else {
            return CGSize(width: width, height: width * 0.8)
        }
    }
}
