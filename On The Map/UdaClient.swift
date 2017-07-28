//
//  UdaClient.swift
//  On The Map
//
//  Created by Markus Staas on 7/21/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import Foundation


class UdaClient : NSObject {
    
    var session: URLSession
    var registered: Bool? = nil
    var sessionID: String? = nil
    var userID: String? = nil
    var expiration: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil

    
 
    override init() {
        session = URLSession.shared
        super.init()
    }
    
 
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject]?, jsonBody: String, completionHandlerForPost: @escaping (_ result: [String:AnyObject]?, _ error: String?) -> Void) -> URLSessionDataTask {
        
        
        var parametersForRequest: [String:AnyObject]? = nil
        if (parameters != nil) {
            parametersForRequest = parameters
        }
        
        let request = NSMutableURLRequest(url: udaURLBuilder(parametersForRequest, withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
       
        
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                completionHandlerForPost(nil, error)
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
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
           
            guard let data = data else {
                
                sendError("No data was returned by the request!")
                return
            }
            
          
            self.convertJSONDataWithCompletionHandler(data, completionHandlerForConvertedData: completionHandlerForPost)
        }
        
        
        task.resume()
        return task
    }
    
   
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject]?, headers: [String:String]?, completionHandlerForGET: @escaping (_ result: [String:AnyObject]?, _ error: String?) -> Void) -> URLSessionDataTask {
        

        var parametersForRequest: [String:AnyObject]? = nil
        if (parameters != nil) {
            parametersForRequest = parameters
        }
        

        let request = NSMutableURLRequest(url: udaURLBuilder(parametersForRequest, withPathExtension: method))
        if (headers != nil) {
            for (key, value) in headers! {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }

      
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                completionHandlerForGET(nil, error)
            }
      
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
          
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            
            self.convertJSONDataWithCompletionHandler(data, completionHandlerForConvertedData: completionHandlerForGET)
        }

        task.resume()
        return task
    }
    

    func logoutSessionWithUdacity(completionHandlerForLogoutSessionWithUdacity: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
               let parameters: [String:AnyObject]? = nil
        let method: String = Methods.LogoutSessionWithUdacity
        
        
        let _ = taskForDELETEMethod(method, parameters: parameters) { (results, error) in
            
           
            guard (error == nil) else {
                completionHandlerForLogoutSessionWithUdacity(false, error)
                return
            }
            guard let sessionDictionary = results?[UdaClient.ResponseKeys.Session] as? [String:AnyObject], let id = sessionDictionary[UdaClient.ResponseKeys.ID] as? String else {
                completionHandlerForLogoutSessionWithUdacity(false, "Could not logout of session")
                return
            }
            if (id != ""), (id.isEmpty == false) {
                completionHandlerForLogoutSessionWithUdacity(true, error)
            } else {
                completionHandlerForLogoutSessionWithUdacity(false, "Could not identify sessionID")
            }
        }
    }

    func taskForDELETEMethod(_ method: String?, parameters: [String:AnyObject]?, completionHandlerForDeleteMethod: @escaping (_ result: [String: AnyObject]?, _ errorString: String?) -> Void) -> URLSessionDataTask {
        
       
        var parametersForRequest: [String:AnyObject]? = nil
        if (parameters != nil) {
            parametersForRequest = parameters
        }
        
       
        let request = NSMutableURLRequest(url: udaURLBuilder(parametersForRequest, withPathExtension: method))
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                completionHandlerForDeleteMethod(nil, error)
            }
            
            guard (error == nil) else {
                print("There was an error with your request")
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request")
                sendError("No data was returned by the request!")
                return
            }
            
            
            self.convertJSONDataWithCompletionHandler(data, completionHandlerForConvertedData: completionHandlerForDeleteMethod)
        }
        
       
        task.resume()
        return task
    }
    
    //////////HELPERS
    // create the URL
    private func udaURLBuilder(_ parameters: [String:AnyObject]?, withPathExtension: String? = nil) -> URL {
        
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
    

    private func convertJSONDataWithCompletionHandler(_ data: Data, completionHandlerForConvertedData: (_ result: [String:AnyObject]?, _ error: String?) -> Void) {
        
        let range = Range(uncheckedBounds: (5, data.count))
        let newData = data.subdata(in: range)
            var parsedResult: [String:AnyObject]!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
        } catch {
            completionHandlerForConvertedData(nil, "Could not serialize the data into JSON")
        }
        completionHandlerForConvertedData(parsedResult, nil)
    }
    

    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        
        if method.range(of: "<\(key)>") != nil {
            return method.replacingOccurrences(of: "<\(key)>", with: value)
        } else {
            return nil
        }
    }
    

    
    class func sharedInstance() -> UdaClient {
        
        struct Singleton {
            static var sharedInstance = UdaClient()
        }
        
        return Singleton.sharedInstance
    }
    

}
