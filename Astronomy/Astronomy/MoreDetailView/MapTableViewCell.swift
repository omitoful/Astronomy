//
//  MapTableViewCell.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/12.
//

import UIKit
import MapKit

class MapTableViewCell: UITableViewCell {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var rateIt: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rateIt.layer.cornerRadius = 20
    }
    
    func configure(location: String) {
        let geoCoder = CLGeocoder()
        
        print(location)
        geoCoder.geocodeAddressString(location, completionHandler: { placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                
                let annotation = MKPointAnnotation()
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                }
                
                // 設定縮放：
                let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                self.mapView.setRegion(region, animated: false)
            }
            
        })
    }
}
