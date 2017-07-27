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
    
    @IBAction func refreshView(_ sender: Any) {
        areWeOnline()
        for annotation: MKAnnotation in mapView.annotations{
            mapView.removeAnnotation(annotation)
        }
        getMapData()
        
    }
    @IBAction func addStudent(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMapData()
    }
    
    func areWeOnline() {
        if !(reachability?.isReachable)! {
            showErrorAlert(message: "Could not connect to the Internet, please connect to the Internet to use this app")
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
    
    
    func getMapData(){
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
                self.setMapData()
            }
    }
    }
    
    func setMapData(){
        var annotations = [MKPointAnnotation]()
        for location in Student.sharedInstance().studentLocationsList{
            let lat = CLLocationDegrees(location.latitude! as Double)
            let long = CLLocationDegrees(location.longitude! as Double)
            let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let firstName = location.firstName! as String
            let lastName = location.lastName! as String
            let linkURL = location.linkURL! as String
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = linkURL
            annotations.append(annotation)
        }
        self.mapView.delegate = self
        self.mapView.addAnnotations(annotations)
        
        
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "identifier"
        var showPin = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        if (showPin == nil) {
            showPin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            showPin!.canShowCallout = true
            showPin!.image = UIImage(named: "icon_pin")
            showPin!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            showPin!.annotation = annotation
            }
        return showPin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            let linkURL = view.annotation?.subtitle!
            if let url = URL(string: linkURL!){
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}
