//
//  BookmarkViewController.swift
//  seouliCard
//
//  Created by 김진형 on 11/02/2019.
//  Copyright © 2019 JinHyeongKim. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController {

    @IBOutlet weak var bookmarkTableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundLabel: UILabel!
    
    var bookmarkList:[String] = []
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let imageKeyMapping = ImageKeyMapping()
    var info : [RowData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if bookmarkList.count == 0 {
            bookmarkTableView.alpha = 0.0
            backgroundImageView.image = UIImage(named: "star")
            backgroundLabel.alpha = 1.0
        } else {
            bookmarkTableView.alpha = 1.0
            backgroundImageView.image = nil
            backgroundLabel.alpha = 0.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        info.removeAll()
        if let dataList = UserDefaults.standard.array(forKey: "bookmark") as? [String]{
            bookmarkList = dataList
        }
        
        for data in bookmarkList {
            for index in 0...delegate.cardInfoList.endIndex-1 {
                if delegate.cardInfoList[index].companyName.contains(data) {
                    info += delegate.cardInfoList.filter({$0.companyName == data})
                }
            }
        }
        
        if bookmarkList.count == 0 {
            bookmarkTableView.alpha = 0.0
            backgroundImageView.image = UIImage(named: "star")
            backgroundLabel.alpha = 1.0
        } else {
            bookmarkTableView.alpha = 1.0
            backgroundImageView.image = nil
            backgroundLabel.alpha = 0.0
        }
        bookmarkTableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailViewController {
            if let cell = sender as? UITableViewCell {
                if let indexPath = bookmarkTableView.indexPath(for: cell) {
                    let target = bookmarkList[indexPath.row]
                    detailVC.receiveTitle = target
                }
            }
        }
    }
}

extension BookmarkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = bookmarkTableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath) as! BookMarkTableViewCell
        
        cell.companyNameLabel.text = info[indexPath.row].companyName
        cell.locationLabel.text = info[indexPath.row].address
        cell.benefitLabel.text = info[indexPath.row].benefit
        
        let target = info[indexPath.row].category
        let imageName = imageKeyMapping.imageDictionary[target] ?? ""
        cell.categoryImageView.image = UIImage(named: imageName)
        cell.locationImageView.image = UIImage(named: "marker")
        
        return cell
    }
}


extension BookmarkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            bookmarkList.remove(at: indexPath.row)
            bookmarkTableView.deleteRows(at: [indexPath], with: .automatic)
            delegate.existBookMarkList.remove(at: indexPath.row) //delegate에서 지우고
            UserDefaults.standard.set(delegate.existBookMarkList, forKey: "bookmark") //지운 배열을 다시 userdefaults에 저장하고
        default:
            return
        }
        
        if bookmarkList.count == 0 {
            bookmarkTableView.alpha = 0.0
            backgroundImageView.image = UIImage(named: "star")
            backgroundLabel.alpha = 1.0
        }
    }
}
