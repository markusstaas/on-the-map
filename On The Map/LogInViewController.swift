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
                    self.showErrorAlert(message: "\(err)")
                    return
                }
                //print(result)
            }
            
        }else{
            print(error)
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User logged out")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //Get delegate and shared session
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        session = URLSession.shared
    
    }

    
    @IBAction func UdaLoginButton(_ sender: Any) {
        let userEmail = userEmailField.text
        let userPassword = userPasswordField.text
        
        guard userEmail?.isEmpty == false else {
            showErrorAlert(message: "Please enter your email address")
            return
        }
        guard userPassword?.isEmpty == false else {
            showErrorAlert(message: "Please enter your password")
            return
        }
        
        
        
        //Udacity log in
        UdaClient.sharedInstance().udaLogin(email: userEmail!, password: userPassword!){
            data, response, error in
            
            if error != nil || data == nil { // Handle network error…
                DispatchQueue.main.async(execute: {
                    self.showErrorAlert(message: "Network or URL error")
                })
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            
            let json: Any!
            do {
                json = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments)
            } catch {
                DispatchQueue.main.async(execute: {
                    self.showErrorAlert(message: "JSON Parsing Error")
                })
                return
            }
            
            let errorMessage = (json as AnyObject)["error"]!
            if errorMessage != nil {
                DispatchQueue.main.async(execute: {
                    self.showErrorAlert(message: "\(errorMessage ?? "")")
                })
                return
            }
            
            // successful login
            DispatchQueue.main.async(execute: {
                self.loginSuccess()
            
                })
            }
            
        }
    
    
    
    func showErrorAlert(message: String, dismissButtonTitle: String = "OK") {
        let controller = UIAlertController(title: "Error Message:", message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: dismissButtonTitle, style: .default) { (action: UIAlertAction!) in
            controller.dismiss(animated: true, completion: nil)
        })
        
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: Log-In successful
    
    func loginSuccess(){
        
        //self.showErrorAlert(message: "Log In worx!!")
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        present(controller, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func FBLoginButton(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self){
            (result, err) in
            if err != nil {
                self.showErrorAlert(message: "\(err)")
                return
            }
           
            let FBToken = (result?.token.tokenString!)! as String
            print(FBToken)
            
            //Udacity log in
            UdaClient.sharedInstance().udaFBLogin(token: FBToken){
                data, response, error in
                
                if error != nil || data == nil { // Handle network error…
                    DispatchQueue.main.async(execute: {
                        self.showErrorAlert(message: "Network or URL error")
                    })
                    return
                }
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range)
               print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
               
                
                let json: Any!
                do {
                    json = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments)
                } catch {
                    DispatchQueue.main.async(execute: {
                        self.showErrorAlert(message: "JSON Parsing Error")
                    })
                    return
                }
                
               let errorMessage = (json as AnyObject)["error"]!
                if errorMessage != nil {
                    DispatchQueue.main.async(execute: {
                        self.showErrorAlert(message: "\(errorMessage ?? "")")
                    })
                    return
                }
                
                // successful login
                DispatchQueue.main.async(execute: {
                    self.loginSuccess()
                    
                })
            }
            
        }
       
    }
}






