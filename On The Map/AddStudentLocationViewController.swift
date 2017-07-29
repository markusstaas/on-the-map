//
//  AddStudentLocationViewController.swift
//  On The Map
//
//  Created by Markus Staas on 7/27/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit

class AddStudentLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userAddressField: UITextField!
    @IBOutlet weak var userURLField: UITextField!
    
    @IBAction func backButt(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        Helper.areWeOnline()
        self.userAddressField.delegate = self
        self.userURLField.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func continueButt(_ sender: Any) {
        Helper.areWeOnline()
        guard userAddressField.text?.isEmpty == false else {
            Helper.showErrorAlert(message: "Please enter your address")
            return
        }
        guard userURLField.text?.isEmpty == false else {
            Helper.showErrorAlert(message: "Please enter your URL")
            return
        }
        
        
        let ConfirmStudentVC = storyboard?.instantiateViewController(withIdentifier: "ConfirmStudentLocationVC") as! ConfirmStudentLocationViewController
        ConfirmStudentVC.userAddress = userAddressField.text!
        ConfirmStudentVC.userURL = userURLField.text!
        navigationController?.pushViewController(ConfirmStudentVC, animated: true)
        
    }

    

}
