//
//  LicenseDetailViewController.swift
//  seouliCard
//
//  Created by 김진형 on 11/02/2019.
//  Copyright © 2019 JinHyeongKim. All rights reserved.
//

import UIKit

class LicenseDetailViewController: UIViewController {

    @IBOutlet weak var licenseTextView: UITextView!
    
    var licenseTitle :String?
    let licenseDict = LicenseString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let license = licenseTitle {
            navigationItem.title = license
            licenseTextView.text = licenseDict.license[license]
        }
    }
}
