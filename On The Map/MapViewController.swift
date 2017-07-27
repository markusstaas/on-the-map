//
//  MapViewController.swift
//  On The Map
//
//  Created by Markus Staas on 7/24/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit
import MapKit
import ReachabilitySwift

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let reachability = Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMapLocations()
    }
    
    func areWeOnline() -> Bool{
        if (reachability?.isReachable)! {
            return true
        }else{
            showErrorAlert(message: "Could not connect to the Internet, please connect to the Internet to use this app")
            return false
        }
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        LoadingIndicator.sharedInstance().startIndicator(self)
        UdaClient.sharedInstance().logoutSessionWithUdacity(){(success, errorString) in
            
            performUIUpdatesOnMain {
                LoadingIndicator.sharedInstance().stopIndicator(self)
                if success{
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showErrorAlert(message: errorString!)
                }
            }
        }
    }
    
    func showErrorAlert(message: String, dismissButtonTitle: String = "Cool") {
        let controller = UIAlertController(title: "Error Message:", message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: dismissButtonTitle, style: .default) { (action: UIAlertAction!) in
            controller.dismiss(animated: true, completion: nil)
        })
        
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func getMapLocations(){
        LoadingIndicator.sharedInstance().startIndicator(self)
        ParseClient.sharedInstance().getStudentLocations(){(success, results, errorString) in
            
            performUIUpdatesOnMain {
                LoadingIndicator.sharedInstance().stopIndicator(self)
                guard (success == true) else {
                    self.showErrorAlert(message: errorString!)
                    return
                }
                guard (results != nil) else {
                    self.showErrorAlert(message: errorString!)
                    return
                }
                self.setMapLocations()
            }
        }
    }
    
    func setMapLocations(){
        var annotations = [MKPointAnnotation]()
        for location in Student.sharedInstance().studentLocationsList{
            let lat = CLLocationDegrees(location.latitude! as Double)
            let long = CLLocationDegrees(location.longitude! as Double)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let firstName = location.firstName! as String
            let lastName = location.lastName! as String
            let mediaURL = location.mediaURL! as String
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }
        self.mapView.delegate = self
        self.mapView.addAnnotations(annotations)
    }
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        if (pinView == nil) {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
}
