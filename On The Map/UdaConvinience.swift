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
    // MARK: Authentication Method
    func authenticateWithViewController(_ hostViewController: UIViewController, username: String?, password: String?, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        /* chain completion handlers for each request so that they run one after the other */
        postSessionWithUdacity(username, password) { (success, sessionID, userID, registered, expiration, errorString) in
            guard (success == true) else {
                print("AuthenticateWithViewController Error")
                completionHandlerForAuth(success, errorString)
                return
            }
            /* We now have the SessionID, UserID, Registered condition, and Expiration */
            self.sessionID = sessionID
            self.userID = userID
            self.registered = registered
            self.expiration = expiration
            
            self.getPublicUserData(userID) { (success, firstName, lastName, errorString) in
                guard (success == true) else {
                    completionHandlerForAuth(success, errorString)
                    return
                }
                /* We now have the user's 'First Name' and 'Last Name' */
                self.firstName = firstName
                self.lastName = lastName
                completionHandlerForAuth(success, errorString)
            }
        }
}
    
    // MARK: FACEBOOKL Authentication Method
    func authenticateWithFBViewController(_ hostViewController: UIViewController, token: String?, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        /* chain completion handlers for each request so that they run one after the other */
        postFBSessionWithUdacity(token) { (success, sessionID, userID, registered, expiration, errorString) in
            guard (success == true) else {
                print("AuthenticateWithFBViewController Error")
                completionHandlerForAuth(success, errorString)
                return
            }
            /* We now have the SessionID, UserID, Registered condition, and Expiration */
            self.sessionID = sessionID
            self.userID = userID
            self.registered = registered
            self.expiration = expiration
            
            self.getPublicUserData(userID) { (success, firstName, lastName, errorString) in
                guard (success == true) else {
                    completionHandlerForAuth(success, errorString)
                    return
                }
                /* We now have the user's 'First Name' and 'Last Name' */
                self.firstName = firstName
                self.lastName = lastName
                completionHandlerForAuth(success, errorString)
            }
        }
    }
    
    
    
    
    
    
    
    
    private func postSessionWithUdacity(_ username: String?, _ password: String?, completionHandlerForUdacityLogin: @escaping (_ success: Bool, _ sessionID: String?, _ userID: String?, _ registered: Bool?, _ expiration: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters (for now, "nil", but good to have if method ever changes) and HTTP body */
        let parameters: [String:AnyObject]? = nil
        let method: String = Methods.AuthenticationSessionNew
        let jsonBody = "{\"\(UdaClient.ParameterKeys.Udacity)\": {\"\(UdaClient.ParameterKeys.UserName)\": \"" + username! + "\", \"\(UdaClient.ParameterKeys.Password)\": \"" + password! + "\"}}"
        
        
        /* 2. Make the request */
        let _ = taskForPOSTMethod(method, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to the completion handler */
            guard (error == nil) else {
                print("postSessionWithUdacity Error")
                completionHandlerForUdacityLogin(false, nil, nil, nil, nil, error)
                return
            }
            guard let sessionDictionary = results?[UdaClient.JSONResponseKeys.Session] as? [String:AnyObject], let accountDictionary = results?[UdaClient.JSONResponseKeys.Account] as? [String:AnyObject], let registered = accountDictionary[UdaClient.JSONResponseKeys.Registered] as? Bool, let sessionID = sessionDictionary[UdaClient.JSONResponseKeys.ID] as? String, let userID = accountDictionary[UdaClient.JSONResponseKeys.Key] as? String?, let expiration = sessionDictionary[UdaClient.JSONResponseKeys.Expiration] as? String else {
                completionHandlerForUdacityLogin(false, nil, nil, nil, nil, "Could not find 'Session ID' and/or 'UserID' in parsed result")
                print("postSessionWithUdacity parsing error")
                return
            }
            //print("session ID is \(sessionID) and user ID is \(String(describing: userID))")
            completionHandlerForUdacityLogin(true, sessionID, userID, registered, expiration, nil)
        }
    }
    private func postFBSessionWithUdacity(_ token: String?, completionHandlerForUdacityLogin: @escaping (_ success: Bool, _ sessionID: String?, _ userID: String?, _ registered: Bool?, _ expiration: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters (for now, "nil", but good to have if method ever changes) and HTTP body */
        let parameters: [String:AnyObject]? = nil
        let method: String = Methods.AuthenticationSessionNew
        let jsonBody = "{\"\(UdaClient.ParameterKeys.Facebook)\": {\"\(UdaClient.ParameterKeys.AccessToken)\":\"\(token!);\"}}"
        
        /* 2. Make the request */
        let _ = taskForPOSTMethod(method, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to the completion handler */
            guard (error == nil) else {
                print("postFBSessionWithUdacity Error")
                completionHandlerForUdacityLogin(false, nil, nil, nil, nil, error)
                return
            }
            guard let sessionDictionary = results?[UdaClient.JSONResponseKeys.Session] as? [String:AnyObject], let accountDictionary = results?[UdaClient.JSONResponseKeys.Account] as? [String:AnyObject], let registered = accountDictionary[UdaClient.JSONResponseKeys.Registered] as? Bool, let sessionID = sessionDictionary[UdaClient.JSONResponseKeys.ID] as? String, let userID = accountDictionary[UdaClient.JSONResponseKeys.Key] as? String?, let expiration = sessionDictionary[UdaClient.JSONResponseKeys.Expiration] as? String else {
                completionHandlerForUdacityLogin(false, nil, nil, nil, nil, "Could not find 'Session ID' and/or 'UserID' in parsed result")
                print("postSessionWithUdacity parsing error")
                return
            }
            //print("session ID is \(sessionID) and user ID is \(String(describing: userID))")
            completionHandlerForUdacityLogin(true, sessionID, userID, registered, expiration, nil)
        }
    }
    
    
    
    
    
    private func getPublicUserData(_ userID: String?, completionHandlerForGetPublicUserData: @escaping (_ success: Bool, _ firstName: String?, _ lastName: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify the parameters */
        let parameters: [String:AnyObject]? = nil
        var mutableMethod: String = Methods.GetPublicUserData
        mutableMethod = substituteKeyInMethod(mutableMethod, key: UdaClient.URLKeys.UserID, value: UdaClient.sharedInstance().userID!)!
        
        /* 2. Make the request */
        let _ = taskForGETMethod(mutableMethod, parameters: parameters, headers: nil) { (results, error) in
            
            /* 3. Send the desired values to the completion handler */
            guard (error == nil) else {
                completionHandlerForGetPublicUserData(false, nil, nil, error)
                return
            }
            
            guard let userDictionary = results?[UdaClient.JSONResponseKeys.User] as? [String:AnyObject], let lastName = userDictionary[UdaClient.JSONResponseKeys.LastName] as? String, let firstName = userDictionary[UdaClient.JSONResponseKeys.FirstName] as? String else {
                completionHandlerForGetPublicUserData(false, nil, nil, "Could not find 'First Name' and/or 'Last Name' in parsed result")
                return
            }
            //print(firstName + " " + lastName)
            completionHandlerForGetPublicUserData(true, firstName, lastName, nil)
        }
    }

    
    
    
    
}
