//
//  DetailViewController.swift
//  seouliCard
//
//  Created by 김진형 on 11/02/2019.
//  Copyright © 2019 JinHyeongKim. All rights reserved.
//

import UIKit
import CoreLocation

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

class DetailViewController: UIViewController, MTMapViewDelegate {
        @IBOutlet weak var companyNameLabel : UILabel!
        @IBOutlet weak var categoryLabel: UILabel!
        @IBOutlet weak var benefitLabel: UILabel!
        @IBOutlet weak var addressLabel: UILabel!
        @IBOutlet weak var telNumberLabel: UILabel!
        @IBOutlet weak var mapView: UIView!
        
        var daumMapView: MTMapView!
        var receiveTitle : String?
        var detailInfo: [RowData] = []
        let delegate = UIApplication.shared.delegate as! AppDelegate
        var latitude: Double?
        var longtitude: Double?
        
        func getDetailDataWithCompanyName(with receiveTitle: String?) -> [RowData] {
            
            if let companyName = receiveTitle {
                detailInfo = delegate.cardInfoList.filter{ $0.companyName == companyName }
            }
            
            return detailInfo
        }
        
        @IBAction func pushCallButton(_ sender: Any?) {
            guard let number = detailInfo.first?.telNumber else {return}
            if let url = URL(string:"tel://\(number)") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        
        func updateFavoritesButton(isExistBookMarkList: Bool) {
            let favoritesBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            favoritesBtn.addTarget(self, action: #selector(storedBookMark(_:)), for: .touchUpInside)
            
            if isExistBookMarkList {
                favoritesBtn.setImage(UIImage(named: "navi_favorites_fill"), for: .normal)
            } else {
                favoritesBtn.setImage(UIImage(named: "navi_favorites"), for: .normal)
            }
            
            let rightBarButton = UIBarButtonItem(customView: favoritesBtn)
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
        
        @objc func storedBookMark(_ sender: Any) {
            if let title = receiveTitle {
                if delegate.existBookMarkList.contains(title) {
                    delegate.existBookMarkList = delegate.existBookMarkList.filter { $0 != title }
                    UserDefaults.standard.set(delegate.existBookMarkList, forKey: "bookmark")
                    updateFavoritesButton(isExistBookMarkList: false)
                } else {
                    delegate.existBookMarkList.append(title)
                    UserDefaults.standard.set(delegate.existBookMarkList, forKey: "bookmark")
                    updateFavoritesButton(isExistBookMarkList: true)
                    showAlert(title: "즐겨찾기에 저장되었습니다.", message: title)
                }
            }
        }
        
        func makeCustomBallonView() -> UIView {
            
            let customBalloonView = UIView(frame: CGRect(x: 0, y: 0, width: self.mapView.bounds.width / 2, height: 30))
            let textLabel = UILabel(frame: customBalloonView.bounds)
            customBalloonView.layer.cornerRadius = 10.0
            customBalloonView.layer.borderWidth = 1.0
            
            if let name = receiveTitle {
                textLabel.text = name
            }
            
            textLabel.textAlignment = .center
            textLabel.backgroundColor = UIColor.white
            textLabel.adjustsFontSizeToFitWidth = true
            customBalloonView.addSubview(textLabel)
            
            return customBalloonView
        }
        
        func presentPOItem(name: String, addressString: String) {
            let geoCoder = CLGeocoder()
            let item = MTMapPOIItem()
            
            let customBalloonView = makeCustomBallonView()
            
            geoCoder.geocodeAddressString(addressString) { (placemarks, error) in
                guard let placemarks = placemarks?.first else {
                    self.showAlert(title: "위치 찾기에 실패했습니다.", message: "")
                    return
                }
                let coordinates:CLLocationCoordinate2D = (placemarks.location?.coordinate)!
                
                item.itemName = name
                item.customCalloutBalloonView = customBalloonView
                item.markerType = .customImage
                item.customImage = UIImage(named: "map_pin_red")
                item.customImageAnchorPointOffset = MTMapImageOffset(offsetX: 30, offsetY: 0)
                item.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: coordinates.latitude, longitude: coordinates.longitude))
                item.showAnimationType = .dropFromHeaven
                
                self.daumMapView.setMapCenter(item.mapPoint, zoomLevel: 1, animated: false)
                self.daumMapView.add(item)
            }
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let targetVC = segue.destination as? DaumMapViewController {
                targetVC.companyName = receiveTitle
                targetVC.address = detailInfo.first?.address
                targetVC.delegate = self
            }
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            guard let address = detailInfo.first?.address else { return }
            guard let name = receiveTitle else { return }
            
            presentPOItem(name: name, addressString: address)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            if let title = receiveTitle {
                if delegate.existBookMarkList.contains(title) {
                    updateFavoritesButton(isExistBookMarkList: true)
                } else {
                    updateFavoritesButton(isExistBookMarkList: false)
                }
                
                daumMapView = MTMapView(frame: self.mapView.bounds)
                daumMapView.delegate = self
                daumMapView.baseMapType = .standard
                
                addressLabel.adjustsFontSizeToFitWidth = true
                addressLabel.textColor = UIColor.gray
                companyNameLabel.adjustsFontSizeToFitWidth = true
                
                let detailInfo = getDetailDataWithCompanyName(with: receiveTitle)
                
                self.navigationItem.title = receiveTitle
                companyNameLabel.text = detailInfo.first?.companyName
                categoryLabel.text = detailInfo.first?.category
                benefitLabel.text = detailInfo.first?.benefit
                addressLabel.text = detailInfo.first?.address
                telNumberLabel.text = detailInfo.first?.telNumber
                
                self.mapView.addSubview(daumMapView)
            }
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            daumMapView.didReceiveMemoryWarning()
        }
}
