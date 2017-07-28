//
//  ConfirmStudentLocationViewController.swift
//  On The Map
//
//  Created by Markus Staas on 7/27/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit

class ConfirmStudentLocationViewController: UIViewController {
    
    var userAddress: String = ""
    var userURL: String = ""
    
    @IBAction func backButt(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("user address \(userAddress)")
        print("user url \(userURL)")
       
    }



}
