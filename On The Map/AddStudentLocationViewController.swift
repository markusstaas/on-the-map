//
//  AddStudentLocationViewController.swift
//  On The Map
//
//  Created by Markus Staas on 7/27/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit

class AddStudentLocationViewController: UIViewController {
    
    @IBOutlet weak var userAddressField: UITextField!
    @IBOutlet weak var userURLField: UITextField!
    
    @IBAction func backButt(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func continueButt(_ sender: Any) {
        
        guard userAddressField.text?.isEmpty == false else {
            showErrorAlert(message: "Please enter your address")
            return
        }
        guard userURLField.text?.isEmpty == false else {
            showErrorAlert(message: "Please enter your URL")
            return
        }
        
        
        
        let ConfirmStudentVC = storyboard?.instantiateViewController(withIdentifier: "ConfirmStudentLocationVC") as! ConfirmStudentLocationViewController
        ConfirmStudentVC.userAddress = userAddressField.text!
        ConfirmStudentVC.userURL = userURLField.text!
        navigationController?.pushViewController(ConfirmStudentVC, animated: true)
        
        
    }
    func showErrorAlert(message: String, dismissButtonTitle: String = "Cool") {
        let controller = UIAlertController(title: "Error Message:", message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: dismissButtonTitle, style: .default) { (action: UIAlertAction!) in
            controller.dismiss(animated: true, completion: nil)
        })
        
        self.present(controller, animated: true, completion: nil)
    }
    

}
