//
//  CoorpListViewController.swift
//  seouliCard
//
//  Created by 김진형 on 11/02/2019.
//  Copyright © 2019 JinHyeongKim. All rights reserved.
//

import UIKit

class CoorpListViewController: UIViewController {

    var categoryList: [RowData] = []
    var filteredCardInfo: [RowData] = []
    var secondFilterdCardInfo:[RowData] = []
    var receiveCategoryFilterObject: String?
    var receiveLocationFilterObject: String?
    var secondFilterObject: String?
    var dataTypeFlag:Bool?
    var isSecondFiltering: Bool = false
    var filterBtn = UIButton(type: .custom)
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundLabel: UILabel!
    @IBOutlet weak var filteredListTableView: UITableView!
    //    @IBOutlet var rightBarBtnItem: UIBarButtonItem!
    
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    func updateBarButtonItem(isFiltering: Bool) {
        let bookmarkBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        bookmarkBtn.addTarget(self, action: #selector(pushFilterBtn), for: .touchUpInside)
        
        if isFiltering {
            bookmarkBtn.setImage(UIImage(named: "navi_filter_fill"), for: .normal)
        } else {
            bookmarkBtn.setImage(UIImage(named: "navi_filter"), for: .normal)
        }
        
        let rightBarButton = UIBarButtonItem(customView: bookmarkBtn)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func pushFilterBtn(_ sender: UIButton) {
        
        self.isSecondFiltering = !self.isSecondFiltering
        
        if isSecondFiltering {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "popoverVC") as! PopOverViewController
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.receiveFlag = dataTypeFlag
            vc.delegate =  self
            present(vc, animated: true, completion: nil)
        } else {
            filteredListTableView.reloadData()
            if let object = receiveCategoryFilterObject {
                self.navigationItem.title = "업종별 (\(object))"
            } else if let object = receiveLocationFilterObject {
                self.navigationItem.title = "지역별 (\(object))"
            }
        }
        if backgroundImageView.image != nil {
            backgroundImageView.image = nil
            backgroundLabel.alpha = 0.0
            filteredListTableView.alpha = 1.0
        }
        self.updateBarButtonItem(isFiltering: isSecondFiltering)
    }
    
    func startSecondFiltering(with object: String) { //delegate method
        secondFilterObject = object
        guard let dataTypeFlag = dataTypeFlag else {return}
        if dataTypeFlag == false {
            self.navigationItem.title = "지역별 (\(object))"
            secondFilterdCardInfo = filteredCardInfo.filter { $0.category == object }
        } else {
            self.navigationItem.title = "업종별 (\(object))"
            secondFilterdCardInfo = filteredCardInfo.filter { $0.address.contains(object) }
        }
        
        if secondFilterdCardInfo.count == 0 {
            backgroundImageView.image = UIImage(named: "search")
            backgroundLabel.alpha = 1.0
            filteredListTableView.alpha = 0.0
        } else {
            backgroundImageView.image = nil
            backgroundLabel.alpha = 0.0
            filteredListTableView.alpha = 1.0
        }
        
        filteredListTableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("showDetailSegue"):
            if let detailVC = segue.destination as? DetailViewController {
                if let cell = sender as? UITableViewCell {
                    if let indexPath = filteredListTableView.indexPath(for: cell) {
                        if isSecondFiltering == false {
                            let target = filteredCardInfo[indexPath.row]
                            detailVC.receiveTitle = target.companyName
                        } else {
                            let target = secondFilterdCardInfo[indexPath.row]
                            detailVC.receiveTitle = target.companyName
                        }
                    }
                }
            }
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateBarButtonItem(isFiltering: isSecondFiltering)
        
        
        guard let cardInfo = delegate?.cardInfoList else { return }
        
        if receiveLocationFilterObject == nil {
            if let object = receiveCategoryFilterObject {
                self.navigationItem.title = "업종별 (\(object))"
                filteredCardInfo = cardInfo.filter{$0.category == object}
            }
        } else {
            if let object = receiveLocationFilterObject {
                self.navigationItem.title = "지역별 (\(object))"
                filteredCardInfo = cardInfo.filter{$0.address.contains(object)}
            }
        }
    }
}


extension CoorpListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSecondFiltering == false {
            return filteredCardInfo.count
        } else {
            return secondFilterdCardInfo.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSecondFiltering == false {
            let cell = filteredListTableView.dequeueReusableCell(withIdentifier: "filterdDataCell") as! FilterListTableViewCell
            let contentView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 5))
            contentView.backgroundColor = UIColor.clear
            cell.contentView.addSubview(contentView)
            cell.companyNameLabel.text = filteredCardInfo[indexPath.row].companyName
            cell.locationLabel.text = filteredCardInfo[indexPath.row].address
            cell.locationImageView.image = UIImage(named: "marker")
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            
            let cell = filteredListTableView.dequeueReusableCell(withIdentifier: "secondFilterCell") as! FilterListTableViewCell
            if secondFilterdCardInfo.count == 0  {
                cell.textLabel?.text = "확인된 정보가 없습니다."
            }
            let contentView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 5))
            contentView.backgroundColor = UIColor.clear
            cell.contentView.addSubview(contentView)
            cell.companyNameLabel.text = secondFilterdCardInfo[indexPath.row].companyName
            cell.locationLabel.text = secondFilterdCardInfo[indexPath.row].address
            cell.locationImageView.image = UIImage(named: "marker")
            cell.selectionStyle = .none
            
            return cell
            
        }
    }
}

extension CoorpListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTrasform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        
        cell.layer.transform = rotationTrasform
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.7) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
}
