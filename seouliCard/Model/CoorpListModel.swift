//
//  CoorpListModel.swift
//  seouliCard
//
//  Created by 김진형 on 11/02/2019.
//  Copyright © 2019 JinHyeongKim. All rights reserved.
//

import Foundation

struct InfoHappycard: Codable {
    var list_total_count: Int
    var RESULT: Result
    var row: [RowData]
}

struct RowData: Codable {
    var category: String
    var companyName: String
    var address: String
    var telNumber: String
    var benefit: String
    
    enum CodingKeys: String, CodingKey {
        case category = "CATEGORY"
        case companyName = "COMPANY_NAME"
        case address = "ADDR"
        case telNumber = "OFFICE_TEL"
        case benefit = "SUPPORT"
    }
}

struct Result: Codable {
    var CODE: String
    var MESSAGE: String
}
