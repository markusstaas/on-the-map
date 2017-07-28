//
//  LogInViewController.swift
//  On The Map
//
//  Created by Markus Staas on 7/19/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LogInViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var userEmailField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!
    
    var appDelegate: AppDelegate!
    var session : URLSession!
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if (error == nil) {
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
                if err != nil {
                    Helper.showErrorAlert(message: "\(String(describing: err))")
                    return
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        session = URLSession.shared
    }
    override func viewDidAppear(_ animated: Bool) {
         Helper.areWeOnline()
    }
    
    @IBAction func UdaLoginButton(_ sender: Any) {
        Helper.areWeOnline()
        let userEmail = userEmailField.text
        let userPassword = userPasswordField.text
        
        
        
        guard userEmail?.isEmpty == false else {
            Helper.showErrorAlert(message: "Please enter your email address")
            return
        }
        guard userPassword?.isEmpty == false else {
            Helper.showErrorAlert(message: "Please enter your password")
            return
        
        
        LoadingIndicator.sharedInstance().startIndicator(self)
        UdaClient.sharedInstance().authenticateWithViewController(self, username: userEmail, password: userPassword){
            (success, errorString) in
            
            performUIUpdatesOnMain {
                LoadingIndicator.sharedInstance().stopIndicator(self)
                if success{
                    self.loginSuccess()
                } else {
                    Helper.showErrorAlert(message: errorString!)
                }
            }
        }
    }
 }


    @IBAction func udaRegister(_ sender: Any) {
        Helper.areWeOnline()
        let url = URL(string: UdaClient.Constants.UdacityRegistration)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    
    }

    
    func loginSuccess(){
        let controller = storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func FBLoginButton(_ sender: Any) {
        Helper.areWeOnline()
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self){
            (result, err) in
            if err != nil {
                Helper.showErrorAlert(message: "\(String(describing: err))")
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
                        Helper.showErrorAlert(message: errorString!)
                    }
                }
            }
            
            
            
        }
    
    }
}






