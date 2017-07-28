//
//  ConfirmStudentLocationViewController.swift
//  On The Map
//
//  Created by Markus Staas on 7/27/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ConfirmStudentLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var userAddress: String = ""
    var userURL: String = ""
    
    @IBAction func backButt(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapPreview()
  
            
        }
    
    func mapPreview(){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(userAddress) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let userLocation = placemarks.first?.location?.coordinate
                else {
                    self.showErrorAlert(message: "The location could not be found, please go back and try again.")
                    return
            }
            self.mapView.mapType = MKMapType.standard
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: userLocation, span: span)
            self.mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation
            annotation.title = "URL"
            annotation.subtitle = self.userURL
            self.mapView.addAnnotation(annotation)
        }
        
    }
    func showErrorAlert(message: String, dismissButtonTitle: String = "Cool") {
        let controller = UIAlertController(title: "Error Message:", message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: dismissButtonTitle, style: .default) { (action: UIAlertAction!) in
            controller.dismiss(animated: true, completion: nil)
        })
        
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
}
