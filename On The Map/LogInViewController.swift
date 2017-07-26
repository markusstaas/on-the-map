//
//  LogInViewController.swift
//  On The Map
//
//  Created by Markus Staas on 7/19/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import ReachabilitySwift

class LogInViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var userEmailField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!
    let reachability = Reachability()
    
    var appDelegate: AppDelegate!
    var session : URLSession!
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if (error == nil) {
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
                if err != nil {
                    self.showErrorAlert(message: "\(err)")
                    return
                }

            }
            
        }else{
            print(error)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        session = URLSession.shared
        
    }
    
    func areWeOnline() -> Bool{
        if (reachability?.isReachable)! {
            return true
            
        }else{
            showErrorAlert(message: "Could not connect to the Internet, please connect to the Internet to use this app")
            return false
        }
    }
    
    @IBAction func UdaLoginButton(_ sender: Any) {
        let userEmail = userEmailField.text
        let userPassword = userPasswordField.text
        
        if areWeOnline() != false{
        
        guard userEmail?.isEmpty == false else {
            showErrorAlert(message: "Please enter your email address")
            return
        }
        guard userPassword?.isEmpty == false else {
            showErrorAlert(message: "Please enter your password")
            return
        }
        
        LoadingIndicator.sharedInstance().startIndicator(self)
        UdaClient.sharedInstance().authenticateWithViewController(self, username: userEmail, password: userPassword){
            (success, errorString) in
            
            performUIUpdatesOnMain {
                LoadingIndicator.sharedInstance().stopIndicator(self)
                if success{
                    self.loginSuccess()
                } else {
                    self.showErrorAlert(message: errorString!)
                }
            }
        }
    }
 }

    @IBAction func udaRegister(_ sender: Any) {
        if areWeOnline() != false{
        let url = URL(string: UdaClient.Constants.UdacityRegistration)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    }
    
    func showErrorAlert(message: String, dismissButtonTitle: String = "Cool") {
        let controller = UIAlertController(title: "Error Message:", message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: dismissButtonTitle, style: .default) { (action: UIAlertAction!) in
            controller.dismiss(animated: true, completion: nil)
        })
        
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: Log-In successful
    
    func loginSuccess(){
        let controller = storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        present(controller, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func FBLoginButton(_ sender: Any) {
        if areWeOnline() != false {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self){
            (result, err) in
            if err != nil {
                self.showErrorAlert(message: "\(err)")
                return
            }
            let FBToken = (result?.token.tokenString)! as String
            
          LoadingIndicator.sharedInstance().startIndicator(self)
            UdaClient.sharedInstance().authenticateWithFBViewController(self, token: FBToken){
                (success, errorString) in
                
                performUIUpdatesOnMain {
                    LoadingIndicator.sharedInstance().stopIndicator(self)
                    if success{
                        self.loginSuccess()
                    } else {
                        self.showErrorAlert(message: errorString!)
                    }
                }
            }
            
            
            
        }
    }
    }
}






