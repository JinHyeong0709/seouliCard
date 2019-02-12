//
//  DaumMapViewController.swift
//  seouliCard
//
//  Created by 김진형 on 11/02/2019.
//  Copyright © 2019 JinHyeongKim. All rights reserved.
//

import UIKit
import CoreLocation

class DaumMapViewController: UIViewController, MTMapViewDelegate {
    
    var companyName: String?
    var address: String?
    var delegate : DetailViewController!
    var daumMapView: MTMapView!
    @IBOutlet weak var mapView: UIView!
    
    
    @IBAction func pushCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
            item.showAnimationType = .noAnimation
            self.daumMapView.setMapCenter(item.mapPoint, zoomLevel: 1, animated: false)
            self.daumMapView.add(item)
        }
    }
    
    func makeCustomBallonView() -> UIView {
        
        let customBalloonView = UIView(frame: CGRect(x: 0, y: 0, width: self.mapView.bounds.width / 2, height: 30))
        let textLabel = UILabel(frame: customBalloonView.bounds)
        customBalloonView.layer.cornerRadius = 10.0
        customBalloonView.layer.borderWidth = 1.0
        
        if let name = companyName {
            textLabel.text = name
        }
        
        textLabel.textAlignment = .center
        textLabel.backgroundColor = UIColor.white
        textLabel.adjustsFontSizeToFitWidth = true
        customBalloonView.addSubview(textLabel)
        
        return customBalloonView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daumMapView = MTMapView(frame: self.mapView.bounds)
        daumMapView.delegate = self
        daumMapView.baseMapType = .standard
        mapView.addSubview(daumMapView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let companyName = companyName, let address = address else {
            return
        }
        self.presentPOItem(name: companyName, addressString: address)
    }
    
}
