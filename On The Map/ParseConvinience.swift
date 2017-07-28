//
//  ParseConvinience.swift
//  On The Map
//
//  Created by Markus Staas on 7/26/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ParseClient (Convenient Resource Methods[s])

extension ParseClient {
    
    // create an array of StudentInformation dictionaries from parsed results
    func getStudentLocations(completionHandlerForGetStudentLocations: @escaping (_ success: Bool, _ results: [Student.StudentInformation]?, _ errorString: String?) -> Void) {
        
        /* 1. Specify the parameters */
        let parameters: [String:AnyObject]? = [
            ParseClient.ParameterKeys.Limit: ParseClient.ParameterValues.Limit as AnyObject,
            ParseClient.ParameterKeys.Order: ParseClient.ParameterValues.Order as AnyObject
        ]
        let method: String = Methods.GetStudentLocations
        let headerFields = ["X-Parse-Application-Id": ParseClient.Constants.ApplicationID, "X-Parse-REST-API-Key": ParseClient.Constants.ApiKey]
        
        /* 2. Make the request */
        let _ = taskForGETMethod(method, parameters: parameters, headers: headerFields) { (results, error) in
            
            /* 3. Send the desired values to the completion handler */
            guard (error == nil) else {
                print("There was an error in getStudentLocations")
                completionHandlerForGetStudentLocations(false, nil, error)
                return
            }
            guard let resultDictionaries = results?[ParseClient.ResponseKeys.Results] as? [[String:AnyObject]] else {
                print("There was an error trying to parse StudentInformation")
                completionHandlerForGetStudentLocations(false, nil, "Could not parse the data for StudentInformation")
                return
            }
            Student.sharedInstance().studentLocationsList = Student.studentInformationFromData(resultDictionaries)
            completionHandlerForGetStudentLocations(true, Student.sharedInstance().studentLocationsList, error)
        }
    }
    
    // POST and/or PUT student information to Parse Api
    func postStudentInformation(mapString: String?, mediaURL: String?, latitude: Double?, longitude: Double?, completionHandlerForPostStudentInformation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        getStudentLocation() { (success, objectId, errorString) in
            guard (success == true) else {
                print("We were not successful posting student information")
                completionHandlerForPostStudentInformation(false, errorString)
                return
            }
            if (objectId != nil) {
                Student.StudentInformation.sharedInstance.objectId = objectId
                self.putStudentLocation(mapString, mediaURL, latitude, longitude: longitude) { (success, errorString) in
                    if success {
                        print("Successfully 'PUT' Student Location")
                        completionHandlerForPostStudentInformation(true, errorString)
                    } else {
                        print("Could not 'PUT' Student Location")
                        completionHandlerForPostStudentInformation(false, "An error occured in putStudentInformation")
                    }
                    
                }
            } else {
                self.postStudentLocation(mapString, mediaURL, latitude, longitude) { (success, objectId, errorString) in
                    if success {
                        print("We were able to 'POST' Student Information")
                        completionHandlerForPostStudentInformation(true, errorString)
                    } else {
                        print("Could not 'POST' Student Information")
                        completionHandlerForPostStudentInformation(false, "An error occured in postStudentLocation")
                    }
                }
            }
        }
    }
    
    // GET student location from Parse Api
    private func getStudentLocation(completionHandlerForGetStudentLocation: @escaping (_ success: Bool, _ objectId: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify the parameters */
        let parameters: [String:AnyObject]? = [
            ParseClient.ParameterKeys.Where: "{\"uniqueKey\":\"\(UdaClient.sharedInstance().userID!)\"}" as AnyObject
        ]
        let method: String = Methods.GetStudentLocation
        let headerFields = ["X-Parse-Application-Id": ParseClient.Constants.ApplicationID, "X-Parse-REST-API-Key": ParseClient.Constants.ApiKey]
        
        /* 2. Make the request */
        let _ = taskForGETMethod(method, parameters: parameters, headers: headerFields) { (results, error) in
            
            /* 3. Send the desired values to the completion handler */
            guard (error == nil) else {
                print("There was an error in getStudentLocation")
                completionHandlerForGetStudentLocation(false, nil, error)
                return
            }
            guard let resultDictionaries = results?[ParseClient.ResponseKeys.Results] as? [[String:AnyObject]], let recentResult = resultDictionaries[resultDictionaries.endIndex - 1] as? [String:AnyObject] else {
                print("There was an error trying to parse StudentInformation")
                completionHandlerForGetStudentLocation(false, nil, "Could not find entry for StudentInformation")
                return
            }
            if let objectId = recentResult[ParseClient.ResponseKeys.ObjectID] as? String {
                completionHandlerForGetStudentLocation(true, objectId, error)
            } else {
                completionHandlerForGetStudentLocation(true, nil, error)
            }
        }
    }
    
    // POST student location to Parse Api
    private func postStudentLocation(_ mapString: String?, _ mediaURL: String?, _ latitude: Double?, _ longitude: Double?, completionHandlerForPostStudentLocation: @escaping (_ success: Bool, _ objectId: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify the parameters (for now, "nil", but good to have if method ever changes) and HTTP body */
        let parameters: [String:AnyObject]? = nil
        let method: String = Methods.PostStudentLocation
        let headerFields = ["X-Parse-Application-Id": ParseClient.Constants.ApplicationID, "X-Parse-REST-API-Key": ParseClient.Constants.ApiKey]
        let jsonBody = "{\"uniqueKey\": \"\(UdaClient.sharedInstance().userID!)\", \"firstName\": \"\(UdaClient.sharedInstance().firstName!)\", \"lastName\": \"\(UdaClient.sharedInstance().lastName!)\",\"mapString\": \"\(mapString!)\", \"mediaURL\": \"\(mediaURL!)\",\"latitude\": \(latitude!), \"longitude\": \(longitude!)}"
        print(jsonBody)
        
        /* 2. Make the request */
        let _ = taskForPOSTMethod(method, parameters: parameters, headers: headerFields, jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired values to the completion handler */
            guard (error == nil) else {
                print("There was an error in postStudentLocation")
                completionHandlerForPostStudentLocation(false, nil, error)
                return
            }
            guard let objectId = results?[ParseClient.ResponseKeys.ObjectID] as? String else {
                print("There was an error trying to parse StudentInformation")
                completionHandlerForPostStudentLocation(false, nil, "Could not parse data for StudentInformation")
                return
            }
            completionHandlerForPostStudentLocation(true, objectId, error)
        }
    }
    
    // PUT student location to Parse Api
    private func putStudentLocation(_ mapString: String?, _ mediaURL: String?, _ latitude: Double?, longitude: Double?, completionHandlerForPutStudentLocation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        /* 1. Specify the parameters (for now, "nil", but good to have if method ever changes) and HTTP body */
        let parameters: [String:AnyObject]? = nil
        var mutableMethod: String = Methods.PutStudentLocation
        mutableMethod = substituteKeyInMethod(mutableMethod, key: ParseClient.ResponseKeys.ObjectID, value: Student.StudentInformation.sharedInstance.objectId!)!
        let headerFields = ["X-Parse-Application-Id": ParseClient.Constants.ApplicationID, "X-Parse-REST-API-Key": ParseClient.Constants.ApiKey]
        let jsonBody = "{\"uniqueKey\": \"\(UdaClient.sharedInstance().userID!)\", \"firstName\": \"\(UdaClient.sharedInstance().firstName!)\", \"lastName\": \"\(UdaClient.sharedInstance().lastName!)\",\"mapString\": \"\(mapString!)\", \"mediaURL\": \"\(mediaURL!)\",\"latitude\": \(latitude!), \"longitude\": \(longitude!)}"
        print(jsonBody)
        
        /* 2. Make the request */
        let _ = taskForPUTMethod(mutableMethod, parameters: parameters, headers: headerFields, jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired values to the completion handler */
            guard (error == nil) else {
                print("There was an error in putStudentLocation")
                completionHandlerForPutStudentLocation(false, error)
                return
            }
            completionHandlerForPutStudentLocation(true, error)
        }
    }
}
