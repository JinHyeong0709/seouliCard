//
//  PopOverViewController.swift
//  seouliCard
//
//  Created by 김진형 on 11/02/2019.
//  Copyright © 2019 JinHyeongKim. All rights reserved.
//

import UIKit

class PopOverViewController: UIViewController {

    @IBOutlet weak var popoverView: UIView!
    @IBOutlet weak var popoverTableView: UITableView!
    @IBOutlet var cancelBtn: UIButton!
    
    var delegate : CoorpListViewController?
    let filteringObject = FilteringOjbect()
    
    var receiveFlag: Bool?
    var typeFlag: Bool = true
    
    @IBAction func cancelFiltering(_ sender: Any) {
        delegate?.updateBarButtonItem(isFiltering: false)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let flag = receiveFlag else { return }
        typeFlag = flag
        print(typeFlag)
        cancelBtn.titleLabel?.textColor = UIColor.red
        popoverView.layer.cornerRadius = 10
        popoverView.layer.masksToBounds = true
        self.view.backgroundColor = UIColor.lightGray
    }
}


extension PopOverViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if typeFlag == true {
            return filteringObject.locationList.count
        } else {
            return filteringObject.categoryList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = popoverTableView.dequeueReusableCell(withIdentifier: "popoverCell", for: indexPath)
        switch typeFlag {
        case true:
            cell.textLabel?.text = filteringObject.locationList[indexPath.row]
        case false:
            cell.textLabel?.text = filteringObject.categoryList[indexPath.row]
        }
        return cell
    }
}

extension PopOverViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var targetList: [String] = []
        
        switch typeFlag {
        case true:
            targetList = filteringObject.locationList
        case false:
            targetList = filteringObject.categoryList
        }
        
        let target = targetList[indexPath.row]
        
        delegate?.startSecondFiltering(with: target)
        self.dismiss(animated: true, completion: nil)
    }
}
