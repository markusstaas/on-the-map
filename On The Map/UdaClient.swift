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
    var registered: Bool? = nil
    var sessionID: String? = nil
    var userID: String? = nil
    var expiration: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil

    
    // MARK: Initializers
    override init() {
        session = URLSession.shared
        super.init()
    }
    
    // MARK: Function for POST method - To POST information to Udacity
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject]?, jsonBody: String, completionHandlerForPost: @escaping (_ result: [String:AnyObject]?, _ error: String?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters (if any) */
        var parametersForRequest: [String:AnyObject]? = nil
        if (parameters != nil) {
            parametersForRequest = parameters
        }
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: udaURLBuilder(parametersForRequest, withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        print(request.httpBody!)
        print(request.url!)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                completionHandlerForPost(nil, error)
            }
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request")
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    print("Your request returned an invalid response. Status Code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid reponse! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                sendError("Invalid Username and/or Password")
                return
            }
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request")
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6 Parse the data and use the data (happens in completion handler) */
            self.convertJSONDataWithCompletionHandler(data, completionHandlerForConvertedData: completionHandlerForPost)
        }
        
        /* 7. Start the request */
        task.resume()
        return task
    }
    
    // MARK: Function for GET method - To GET information from Udacity
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject]?, headers: [String:String]?, completionHandlerForGET: @escaping (_ result: [String:AnyObject]?, _ error: String?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters (if any) */
        var parametersForRequest: [String:AnyObject]? = nil
        if (parameters != nil) {
            parametersForRequest = parameters
        }
        
        /* 2/3. Build the URL,  Configure the request */
        let request = NSMutableURLRequest(url: udaURLBuilder(parametersForRequest, withPathExtension: method))
        if (headers != nil) {
            for (key, value) in headers! {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        print(request.url!)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                completionHandlerForGET(nil, error)
            }
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertJSONDataWithCompletionHandler(data, completionHandlerForConvertedData: completionHandlerForGET)
        }
        /* 7. Start the task */
        task.resume()
        return task
    }
    
    
    //////////HELPERS
    // create the URL
    private func udaURLBuilder(_ parameters: [String:AnyObject]?, withPathExtension: String? = nil) -> URL {
        
        print("paras are \(parameters)")
        var components = URLComponents()
        components.scheme = UdaClient.Constants.ApiScheme
        components.host = UdaClient.Constants.ApiHost
        components.path = UdaClient.Constants.ApiPath + (withPathExtension ?? "")
        guard (parameters != nil) else {
            return components.url!
        }
        for (key, value) in parameters! {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        return components.url!
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertJSONDataWithCompletionHandler(_ data: Data, completionHandlerForConvertedData: (_ result: [String:AnyObject]?, _ error: String?) -> Void) {
        
        let range = Range(uncheckedBounds: (5, data.count))
        let newData = data.subdata(in: range)
        print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
        var parsedResult: [String:AnyObject]!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
        } catch {
            completionHandlerForConvertedData(nil, "Could not serialize the data into JSON")
        }
        completionHandlerForConvertedData(parsedResult, nil)
    }
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        
        if method.range(of: "<\(key)>") != nil {
            return method.replacingOccurrences(of: "<\(key)>", with: value)
        } else {
            return nil
        }
    }
    
    
    
    
    ///////////OLD
    /*
    
    
    
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
    
    }*/
    
    // MARK: - Shared Instance -- Singleton
    
    class func sharedInstance() -> UdaClient {
        
        struct Singleton {
            static var sharedInstance = UdaClient()
        }
        
        return Singleton.sharedInstance
    }
    

}
