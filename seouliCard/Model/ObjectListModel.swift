//
//  ObjectListModel.swift
//  seouliCard
//
//  Created by 김진형 on 11/02/2019.
//  Copyright © 2019 JinHyeongKim. All rights reserved.
//

import Foundation

import UIKit

struct FilteringOjbect {
    let locationList:[String] = ["강서구", "양천구", "구로구", "금천구","영등포구","마포구","서대문구","은평구","관악구","동작구","용산","중구","종로구","서초구","강남구","송파구","강동구","성동구","동대문구","성북구","강북구","도봉구","노원구","중랑구","광진구"].sorted()
    let categoryList : [String] = ["건강/의료","공영주차장","교육","도서관","마트/식품","문화/체육","생활/금융","도서/문구","외식","청소년시설","출산/육아","기타"]
}

struct ImageKeyMapping {
    let imageDictionary : [String:String] = ["건강/의료":"health","공영주차장":"car_park","교육":"education","도서관":"library","마트/식품":"shop","문화/체육":"ticket","생활/금융":"bank","도서/문구":"book","외식":"food","청소년시설":"youth","출산/육아":"baby","기타":"exception"]
}
