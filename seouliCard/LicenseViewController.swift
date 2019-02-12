//
//  LicenseViewController.swift
//  seouliCard
//
//  Created by 김진형 on 11/02/2019.
//  Copyright © 2019 JinHyeongKim. All rights reserved.
//

import UIKit

class LicenseViewController: UIViewController {

    let licenseArray = ["Freepik(Image)"]
    @IBOutlet weak var licenseTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pushCancelButton(_sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let targetVC = segue.destination as? LicenseDetailViewController {
            if let cell = sender as? UITableViewCell {
                if let indexPath = licenseTableView.indexPath(for: cell) {
                    targetVC.licenseTitle = licenseArray[indexPath.row]
                }
            }
        }
    }
}

extension LicenseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return licenseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = licenseTableView.dequeueReusableCell(withIdentifier: "licenseCell", for: indexPath)
        
        cell.textLabel?.text = licenseArray[indexPath.row]
        
        return cell
    }
}
