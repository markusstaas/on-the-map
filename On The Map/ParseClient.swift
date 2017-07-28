//
//  ParseClient.swift
//  On The Map
//
//  Created by Markus Staas on 7/26/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import Foundation

// MARK: - ParseClient: NSObject

class ParseClient: NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // shared properties
    var objectId: String? = nil
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    // MARK: GET
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject]?, headers: [String:String]?, completionHandlerForGET: @escaping (_ result: [String:AnyObject]?, _ error: String?) -> Void) -> URLSessionDataTask {
        
        
        /* 1. Set the parameters (if any) */
        var parametersForRequest: [String:AnyObject]? = nil
        if (parameters != nil) {
            parametersForRequest = parameters
        }
        
        /* 2/3. Build the URL,  Configure the request */
        let request = NSMutableURLRequest(url: parseURLBuilder(parametersForRequest, withPathExtension: method))
        if (headers != nil) {
            for (key, value) in headers! {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }

        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
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
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertedData: completionHandlerForGET)
        }
        
        /* 7. Start the task */
        task.resume()
        return task
    }
    
    // MARK: POST
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject]?, headers: [String:String]?, jsonBody: String, completionHandlerForPost: @escaping (_ result: [String:AnyObject]?, _ error: String?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters (if any) */
        var parametersForRequest: [String:AnyObject]? = nil
        if (parameters != nil) {
            parametersForRequest = parameters
        }
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: parseURLBuilder(parametersForRequest, withPathExtension: method))
        request.httpMethod = "POST"
        if (headers != nil) {
            for (key, value) in headers! {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
      
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                completionHandlerForPost(nil, error)
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
            
            /* 5/6 Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertedData: completionHandlerForPost)
        }
        
        /* 7. Start the request */
        task.resume()
        return task
    }
    
    // MARK: PUT
    func taskForPUTMethod(_ method: String, parameters: [String:AnyObject]?, headers: [String:String]?, jsonBody: String, completionHandlerForPost: @escaping (_ result: [String:AnyObject]?, _ error: String?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters (if any) */
        var parametersForRequest: [String:AnyObject]? = nil
        if (parameters != nil) {
            parametersForRequest = parameters
        }
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: parseURLBuilder(parametersForRequest, withPathExtension: method))
        request.httpMethod = "PUT"
        if (headers != nil) {
            for (key, value) in headers! {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
       
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                completionHandlerForPost(nil, error)
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
    
            // 5/6 Parse the data and use the data
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertedData: completionHandlerForPost)
        }
        
        // 7. Start the request
        task.resume()
        return task
    }
    

    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        
        if method.range(of: "<\(key)>") != nil {
            return method.replacingOccurrences(of: "<\(key)>", with: value)
        } else {
            return nil
        }
    }
    
    // create a url from parameters
    private func parseURLBuilder(_ parameters: [String:AnyObject]?, withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
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
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertedData: (_ result: [String:AnyObject]?, _ error: String?) -> Void) {
        
        
        var parsedResult: [String:AnyObject]?
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
        } catch {
            completionHandlerForConvertedData(nil, "Could not serialize the data into JSON")
        }
        completionHandlerForConvertedData(parsedResult, nil)
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}

