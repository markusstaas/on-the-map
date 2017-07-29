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
    
    @IBOutlet weak var submitButton: UIButton!
    var userAddress: String = ""
    var userURL: String = ""
    var userLongitude: Double = 0.0
    var userLatitude: Double = 0.0
    
    @IBAction func backButt(_ sender: Any) {
            dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButt(_ sender: Any) {
       Helper.areWeOnline()
        LoadingIndicator.sharedInstance().startIndicator(self)
            ParseClient.sharedInstance().postStudentInformation(mapString: userAddress, mediaURL: userURL, latitude: userLatitude, longitude: userLongitude) { (success, errorString) in
                
                performUIUpdatesOnMain {
                    LoadingIndicator.sharedInstance().stopIndicator(self)
                    if success {
                        
                        Helper.showErrorAlert(message: "Data successfully submitted")
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        Helper.showErrorAlert(message: "Update error: \(String(describing: errorString))")
                    }
                }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapPreview()
            
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        Helper.areWeOnline()
    }
    
    
    func mapPreview(){
        let geoCoder = CLGeocoder()
        LoadingIndicator.sharedInstance().startIndicator(self)
        geoCoder.geocodeAddressString(userAddress) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let userLocation = placemarks.first?.location?.coordinate
                else {
                    LoadingIndicator.sharedInstance().stopIndicator(self)
                Helper.showErrorAlert(message: "The location could not be found, please go back and try again.")
                self.submitButton.isEnabled = false
                self.submitButton.alpha = 0.25
                    return
            }
            self.userLatitude = userLocation.latitude
            self.userLongitude = userLocation.longitude
            self.mapView.mapType = MKMapType.standard
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: userLocation, span: span)
            self.mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation
            annotation.title = "URL"
            annotation.subtitle = self.userURL
            self.mapView.addAnnotation(annotation)
            LoadingIndicator.sharedInstance().stopIndicator(self)
        }
    }
}
