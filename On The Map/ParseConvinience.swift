//
//  ParseConvinience.swift
//  On The Map
//
//  Created by Markus Staas on 7/26/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import Foundation
import UIKit


extension ParseClient {
    

    func getStudentLocations(completionHandlerForGetStudentLocations: @escaping (_ success: Bool, _ results: [Student.StudentInformation]?, _ errorString: String?) -> Void) {
        

        let parameters: [String:AnyObject]? = [
            ParseClient.ParameterKeys.Limit: ParseClient.ParameterValues.Limit as AnyObject,
            ParseClient.ParameterKeys.Order: ParseClient.ParameterValues.Order as AnyObject
        ]
        let method: String = Methods.GetStudentLocations
        let headerFields = ["X-Parse-Application-Id": ParseClient.Constants.ApplicationID, "X-Parse-REST-API-Key": ParseClient.Constants.ApiKey]
        
              let _ = taskForGETMethod(method, parameters: parameters, headers: headerFields) { (results, error) in
            

            guard (error == nil) else {
                completionHandlerForGetStudentLocations(false, nil, error)
                return
            }
            guard let resultDictionaries = results?[ParseClient.ResponseKeys.Results] as? [[String:AnyObject]] else {
            completionHandlerForGetStudentLocations(false, nil, "Could not parse the data for StudentInformation")
                return
            }
            Student.sharedInstance().studentLocationsList = Student.studentInformationFromData(resultDictionaries)
            completionHandlerForGetStudentLocations(true, Student.sharedInstance().studentLocationsList, error)
        }
    }
    //Parse Api
    func postStudentInformation(mapString: String?, mediaURL: String?, latitude: Double?, longitude: Double?, completionHandlerForPostStudentInformation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        getStudentLocation() { (success, objectId, errorString) in
            guard (success == true) else {
                
                completionHandlerForPostStudentInformation(false, errorString)
                return
            }
            if (objectId != nil) {
                Student.StudentInformation.sharedInstance.objectId = objectId
                self.putStudentLocation(mapString, mediaURL, latitude, longitude: longitude) { (success, errorString) in
                    if success {
                        completionHandlerForPostStudentInformation(true, errorString)
                    } else {
                        completionHandlerForPostStudentInformation(false, "An error occured in putStudentInformation")
                    }
                    
                }
            } else {
                self.postStudentLocation(mapString, mediaURL, latitude, longitude) { (success, objectId, errorString) in
                    if success {
                        completionHandlerForPostStudentInformation(true, errorString)
                    } else {
                        completionHandlerForPostStudentInformation(false, "An error occured in postStudentLocation")
                    }
                }
            }
        }
    }

    private func getStudentLocation(completionHandlerForGetStudentLocation: @escaping (_ success: Bool, _ objectId: String?, _ errorString: String?) -> Void) {
        
       
        let parameters: [String:AnyObject]? = [
            ParseClient.ParameterKeys.Where: "{\"uniqueKey\":\"\(UdaClient.sharedInstance().userID!)\"}" as AnyObject
        ]
        let method: String = Methods.GetStudentLocation
        let headerFields = ["X-Parse-Application-Id": ParseClient.Constants.ApplicationID, "X-Parse-REST-API-Key": ParseClient.Constants.ApiKey]
        
        
        let _ = taskForGETMethod(method, parameters: parameters, headers: headerFields) { (results, error) in
            guard (error == nil) else {
            completionHandlerForGetStudentLocation(false, nil, error)
                return
            }
            guard let resultDictionaries = results?[ParseClient.ResponseKeys.Results] as? [[String:AnyObject]],
                let recentResult = resultDictionaries[resultDictionaries.endIndex - 1] as? [String:AnyObject] else {
                
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
    
    private func postStudentLocation(_ mapString: String?, _ mediaURL: String?, _ latitude: Double?, _ longitude: Double?, completionHandlerForPostStudentLocation: @escaping (_ success: Bool, _ objectId: String?, _ errorString: String?) -> Void) {
        
        let parameters: [String:AnyObject]? = nil
        let method: String = Methods.PostStudentLocation
        let headerFields = ["X-Parse-Application-Id": ParseClient.Constants.ApplicationID, "X-Parse-REST-API-Key": ParseClient.Constants.ApiKey]
        let jsonBody = "{\"uniqueKey\": \"\(UdaClient.sharedInstance().userID!)\", \"firstName\": \"\(UdaClient.sharedInstance().firstName!)\", \"lastName\": \"\(UdaClient.sharedInstance().lastName!)\",\"mapString\": \"\(mapString!)\", \"mediaURL\": \"\(mediaURL!)\",\"latitude\": \(latitude!), \"longitude\": \(longitude!)}"
        
        let _ = taskForPOSTMethod(method, parameters: parameters, headers: headerFields, jsonBody: jsonBody) { (results, error) in
            
            guard (error == nil) else {
                completionHandlerForPostStudentLocation(false, nil, error)
                return
            }
            guard let objectId = results?[ParseClient.ResponseKeys.ObjectID] as? String else {
                completionHandlerForPostStudentLocation(false, nil, "Could not parse data for StudentInformation")
                return
            }
            completionHandlerForPostStudentLocation(true, objectId, error)
        }
    }
    
    private func putStudentLocation(_ mapString: String?, _ mediaURL: String?, _ latitude: Double?, longitude: Double?, completionHandlerForPutStudentLocation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {

        let parameters: [String:AnyObject]? = nil
        var mutableMethod: String = Methods.PutStudentLocation
        mutableMethod = substituteKeyInMethod(mutableMethod, key: ParseClient.ResponseKeys.ObjectID, value: Student.StudentInformation.sharedInstance.objectId!)!
        let headerFields = ["X-Parse-Application-Id": ParseClient.Constants.ApplicationID, "X-Parse-REST-API-Key": ParseClient.Constants.ApiKey]
        let jsonBody = "{\"uniqueKey\": \"\(UdaClient.sharedInstance().userID!)\", \"firstName\": \"\(UdaClient.sharedInstance().firstName!)\", \"lastName\": \"\(UdaClient.sharedInstance().lastName!)\",\"mapString\": \"\(mapString!)\", \"mediaURL\": \"\(mediaURL!)\",\"latitude\": \(latitude!), \"longitude\": \(longitude!)}"
        let _ = taskForPUTMethod(mutableMethod, parameters: parameters, headers: headerFields, jsonBody: jsonBody) { (results, error) in
            
            guard (error == nil) else {
                completionHandlerForPutStudentLocation(false, error)
                return
            }
            completionHandlerForPutStudentLocation(true, error)
        }
    }
}
