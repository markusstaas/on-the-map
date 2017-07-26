//
//  UdaConvinience.swift
//  On The Map
//
//  Created by Markus Staas on 7/25/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import Foundation
import UIKit

extension UdaClient{
   
    func authenticateWithViewController(_ hostViewController: UIViewController, username: String?, password: String?, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
      
        postSessionWithUdacity(username, password) { (success, sessionID, userID, registered, expiration, errorString) in
            guard (success == true) else {
                print("AuthenticateWithViewController Error")
                completionHandlerForAuth(success, errorString)
                return
            }

            self.sessionID = sessionID
            self.userID = userID
            self.registered = registered
            self.expiration = expiration
            
            self.getPublicUserData(userID) { (success, firstName, lastName, errorString) in
                guard (success == true) else {
                    completionHandlerForAuth(success, errorString)
                    return
                }

                self.firstName = firstName
                self.lastName = lastName
                completionHandlerForAuth(success, errorString)
            }
        }
}
    
    // MARK: FACEBOOK Authentication
    func authenticateWithFBViewController(_ hostViewController: UIViewController, token: String?, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        
        postFBSessionWithUdacity(token) { (success, sessionID, userID, registered, expiration, errorString) in
            guard (success == true) else {
                print("AuthenticateWithFBViewController Error")
                completionHandlerForAuth(success, errorString)
                return
            }
            
            self.sessionID = sessionID
            self.userID = userID
            self.registered = registered
            self.expiration = expiration
            
            self.getPublicUserData(userID) { (success, firstName, lastName, errorString) in
                guard (success == true) else {
                    completionHandlerForAuth(success, errorString)
                    return
                }
                
                self.firstName = firstName
                self.lastName = lastName
                completionHandlerForAuth(success, errorString)
            }
        }
    }
    
    
    private func postSessionWithUdacity(_ username: String?, _ password: String?, completionHandlerForUdacityLogin: @escaping (_ success: Bool, _ sessionID: String?, _ userID: String?, _ registered: Bool?, _ expiration: String?, _ errorString: String?) -> Void) {
        
        // 1. Specify parameters
        let parameters: [String:AnyObject]? = nil
        let method: String = Methods.AuthenticationSession
        let jsonBody = "{\"\(UdaClient.ParameterKeys.Udacity)\": {\"\(UdaClient.ParameterKeys.UserName)\": \"" + username! + "\", \"\(UdaClient.ParameterKeys.Password)\": \"" + password! + "\"}}"
        
        
        // 2. Make the request
        let _ = taskForPOSTMethod(method, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            // 3. Send values to the completion handler
            guard (error == nil) else {
                print("postSessionWithUdacity Error")
                completionHandlerForUdacityLogin(false, nil, nil, nil, nil, error)
                return
            }
            guard let sessionDictionary = results?[UdaClient.ResponseKeys.Session] as? [String:AnyObject], let accountDictionary = results?[UdaClient.ResponseKeys.Account] as? [String:AnyObject], let registered = accountDictionary[UdaClient.ResponseKeys.Registered] as? Bool, let sessionID = sessionDictionary[UdaClient.ResponseKeys.ID] as? String, let userID = accountDictionary[UdaClient.ResponseKeys.Key] as? String?, let expiration = sessionDictionary[UdaClient.ResponseKeys.Expiration] as? String else {
                completionHandlerForUdacityLogin(false, nil, nil, nil, nil, "Could not find 'Session ID' and/or 'UserID' in parsed result")
                print("postSessionWithUdacity parsing error")
                return
            }
        
            completionHandlerForUdacityLogin(true, sessionID, userID, registered, expiration, nil)
        }
    }
    private func postFBSessionWithUdacity(_ token: String?, completionHandlerForUdacityLogin: @escaping (_ success: Bool, _ sessionID: String?, _ userID: String?, _ registered: Bool?, _ expiration: String?, _ errorString: String?) -> Void) {
        
        //1. Specify parameters
        let parameters: [String:AnyObject]? = nil
        let method: String = Methods.AuthenticationSession
        let jsonBody = "{\"\(UdaClient.ParameterKeys.Facebook)\": {\"\(UdaClient.ParameterKeys.AccessToken)\":\"\(token!);\"}}"
        
        //2. Make the request
        let _ = taskForPOSTMethod(method, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            //3. Send values to the completion handler
            guard (error == nil) else {
                print("postFBSessionWithUdacity Error")
                completionHandlerForUdacityLogin(false, nil, nil, nil, nil, error)
                return
            }
            guard let sessionDictionary = results?[UdaClient.ResponseKeys.Session] as? [String:AnyObject], let accountDictionary = results?[UdaClient.ResponseKeys.Account] as? [String:AnyObject], let registered = accountDictionary[UdaClient.ResponseKeys.Registered] as? Bool, let sessionID = sessionDictionary[UdaClient.ResponseKeys.ID] as? String, let userID = accountDictionary[UdaClient.ResponseKeys.Key] as? String?, let expiration = sessionDictionary[UdaClient.ResponseKeys.Expiration] as? String else {
                completionHandlerForUdacityLogin(false, nil, nil, nil, nil, "Could not find 'Session ID' and/or 'UserID' in parsed result")
                print("postSessionWithUdacity parsing error")
                return
            }
            completionHandlerForUdacityLogin(true, sessionID, userID, registered, expiration, nil)
        }
    }

    
    private func getPublicUserData(_ userID: String?, completionHandlerForGetPublicUserData: @escaping (_ success: Bool, _ firstName: String?, _ lastName: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify the parameters */
        let parameters: [String:AnyObject]? = nil
        var mutableMethod: String = Methods.GetUserData
        mutableMethod = substituteKeyInMethod(mutableMethod, key: UdaClient.URLKeys.UserID, value: UdaClient.sharedInstance().userID!)!
        
        /* 2. Make the request */
        let _ = taskForGETMethod(mutableMethod, parameters: parameters, headers: nil) { (results, error) in
            
            /* 3. Send the desired values to the completion handler */
            guard (error == nil) else {
                completionHandlerForGetPublicUserData(false, nil, nil, error)
                return
            }
            
            guard let userDictionary = results?[UdaClient.ResponseKeys.User] as? [String:AnyObject], let lastName = userDictionary[UdaClient.ResponseKeys.LastName] as? String, let firstName = userDictionary[UdaClient.ResponseKeys.FirstName] as? String else {
                completionHandlerForGetPublicUserData(false, nil, nil, "Could not find 'First Name' and/or 'Last Name' in parsed result")
                return
            }
            completionHandlerForGetPublicUserData(true, firstName, lastName, nil)
        }
    }

    
    
    
    
}
