//
//  MapViewController.swift
//  On The Map
//
//  Created by Markus Staas on 7/24/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    

}
