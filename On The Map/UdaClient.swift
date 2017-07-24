//
//  UdaClient.swift
//  On The Map
//
//  Created by Markus Staas on 7/21/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import Foundation

class UdaClient : NSObject {
    
    // MARK: Properties
    var session: URLSession
    var userKey: String
    var sessionID: String

    
    // MARK: Initializers
    override init() {
        session = URLSession.shared
        userKey = ""
        sessionID = ""
        super.init()
    }
    
    
    // MARK: Udacity Log In
    public func udaLogin(email: String, password: String, handler: @escaping (_ data: Data?, _ response: AnyObject?, _ error: String?) -> Void)  {
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(Constants.BaseURL)/\(Methods.Session)")! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"\(ParameterKeys.Udacity)\": {\"\(ParameterKeys.Username)\": \"\(email)\", \"\(ParameterKeys.Password)\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            handler(data, response, error as? String)
        }
        task.resume()
    }
    
    // MARK: Facebook Log In
    public func udaFBLogin(token: String, handler: @escaping (_ data: Data?, _ response: AnyObject?, _ error: String?) -> Void)  {
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(Constants.BaseURL)/\(Methods.Session)")! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"\(ParameterKeys.Facebook)\": {\"\(ParameterKeys.AccessToken)\":\"\(token);\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            handler(data, response, error as? String)
        }
        task.resume()
    }
    
    
    
    // MARK: Get SessionID
    
    
    
    
    
    // MARK: POST
    
   func taskForPostMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
    //
    
        /* 2/3. Build the URL, Configure the request */
    let request = NSMutableURLRequest(url: NSURL(string: "\(Constants.BaseURL)/\(Methods.Session)")! as URL)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = "{\"\(ParameterKeys.Udacity)\": {\"\(ParameterKeys.Username)\": \"account@domain.com\", \"\(ParameterKeys.Password)\": \"********\"}}".data(using: String.Encoding.utf8)
        
        /* 4. Make the request */
    
    
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
        if error != nil { // Handle error…
            return
        }
        
    
    }

            /* GUARD: Was there an error? */
          
            
            /* GUARD: Did we get a successful 2XX response? */
          
            
            /* GUARD: Was there any data returned? */
        
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
       
        
        /* 7. Start the request */
        task.resume()
        return task
    
    }
    
    // MARK: - Shared Instance -- Singleton
    
    class func sharedInstance() -> UdaClient {
        
        struct Singleton {
            static var sharedInstance = UdaClient()
        }
        
        return Singleton.sharedInstance
    }
    

}
