//
//  ViewController.swift
//  seouliCard
//
//  Created by 김진형 on 11/02/2019.
//  Copyright © 2019 JinHyeongKim. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBarTopLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    let FETCH_SIZE = 1000
    var filteredData: [String] = [] //필터링 된 데이터 저장
    var companyNameData: [String] = [] //회사명 원본 데이터
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    
    @IBOutlet weak var searchBarTopLabel : UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailViewController {
            if let cell = sender as? SearchTableViewCell {
                if let indexPath = searchTableView.indexPath(for: cell) {
                    let target = filteredData[indexPath.row]
                    detailVC.receiveTitle = target // companyName을 navigation title로 넘김
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.tableViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func pushCancelButton(_ sender: Any) {
        searchBar.text = ""
        
        UIView.animate(withDuration: 0.3) {
            self.searchTableView.alpha = 0.0
            self.searchBarTopLabel.alpha = 0.0
            self.cancelButton.alpha = 0.0
            self.searchBarTopLabelConstraint.constant = 100
            self.view.layoutIfNeeded()
        }
        
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchURL()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        searchBar.placeholder = "업체(상호)명으로 검색해 주세요."
        searchBar.searchBarStyle = .minimal
        
        searchTableView.alpha = 0.0
        searchBarTopLabel.alpha = 0.0
        cancelButton.alpha = 0.0
        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.estimatedRowHeight = 200
        searchTableView.backgroundColor = UIColor.clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        
        UIView.animate(withDuration: 0.3) {
            self.tableViewBottomConstraint.constant = keyboardRectangle.height-50
            self.view.layoutIfNeeded()
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.3) {
            self.tableViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        
    }
    
    func fetchURL() {
        self.indicator.startAnimating()
        DispatchQueue.global().async {
            let fetchData:[RowData] = stride(from: 0, to: 4000, by: self.FETCH_SIZE).compactMap {
                let urlStr = "http://openapi.seoul.go.kr:8088/4d67624277776c733239754a774552/json/InfoHappycard/\($0)/\($0 + self.FETCH_SIZE - 1)/"
                guard let url = URL(string: urlStr), let data = try? Data(contentsOf: url) else {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Invalid URL or Data", message: "Please run it again")
                    }
                    fatalError("Invalid Url or data")
                }
                do {
                    let decoder = JSONDecoder()
                    let parsed = try decoder.decode([String: InfoHappycard].self, from: data)
                    return parsed["InfoHappycard"]?.row
                } catch {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Parsing Error", message: "Please run it again")
                    }
                    fatalError("Parsing Error: \(error.localizedDescription)")
                }
                }.reduce([], +)
            fetchData.forEach { self.delegate?.cardInfoList.append($0)}
            self.delegate?.cardInfoList.forEach { self.companyNameData.append($0.companyName) }
        }
        indicator.stopAnimating()
    }
    
    
    //MARK: - SearchBar Method
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            UIView.animate(withDuration: 0.3) {
                self.searchTableView.alpha = 0.0
                self.searchBarTopLabel.alpha = 0.0
                self.cancelButton.alpha = 0.0
                self.searchBarTopLabelConstraint.constant = 100
                //                self.searchBar.showsCancelButton = false
                self.view.layoutIfNeeded()
            }
            
        } else {
            filteredData = companyNameData.filter({ (nameString) -> Bool in
                UIView.animate(withDuration: 0.3) {
                    self.searchTableView.alpha = 1.0
                    self.searchBarTopLabel.alpha = 1.0
                    self.cancelButton.alpha = 1.0
                    self.searchBarTopLabelConstraint.constant = 10
                    self.view.layoutIfNeeded()
                }
                
                return (nameString.range(of: searchText, options: .caseInsensitive) != nil)
            })
        }
        searchTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //        self.searchBar.showsCancelButton = true
        self.searchBar.text = ""
        
        self.searchBar.resignFirstResponder()
        
        UIView.animate(withDuration: 0.3) {
            self.searchTableView.alpha = 0.0
            self.searchBarTopLabel.alpha = 0.0
            self.cancelButton.alpha = 0.0
            self.searchBarTopLabelConstraint.constant = 100
            self.view.layoutIfNeeded()
        }
    }
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchTableViewCell
        let target = filteredData[indexPath.row]
        cell.textLabel?.text = target
        cell.selectionStyle = .none
        
        return cell
    }
}


