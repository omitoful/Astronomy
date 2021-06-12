//
//  MapViewController.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/12.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var bigMapView: MKMapView!
    
    var picture = Picture(url: "", title: "", hdurl: "", date: "", copyright: "", description: "", rating: "")
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identfier = "myMarker"
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        var annotationView: MKMarkerAnnotationView? = bigMapView.dequeueReusableAnnotationView(withIdentifier: identfier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identfier)
        }
        
        annotationView?.glyphText = "😇"
        annotationView?.markerTintColor = UIColor.orange
        
        return annotationView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bigMapView.delegate = self
        bigMapView.showsCompass = true
        bigMapView.showsScale = true
        bigMapView.showsTraffic = true
        

        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString("115台北市南港區南港路一段313號", completionHandler: { placemarks, error in
            if let error = error {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                let annotation = MKPointAnnotation()
                annotation.title = self.picture.title
                annotation.subtitle = self.picture.date
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    self.bigMapView.showAnnotations([annotation], animated: true)
                    self.bigMapView.selectAnnotation(annotation, animated: true)
                }
            }
        })
        
    }

}
