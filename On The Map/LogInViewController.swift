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
                    print(err)
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
        
    
    }
    
    
    
    @IBAction func FBLoginButton(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self){
            (result, err) in
            if err != nil {
                print("Custom log-in failed: ", err)
                return
            }
            print(result?.token.tokenString!)
            
        }
       
    }
    




}

