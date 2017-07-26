//
//  StudentLocations.swift
//  On The Map
//
//  Created by Markus Staas on 7/26/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import Foundation
import UIKit

// MARK: Student information

class Student {
    
    // MARK: Properties
    var studentLocationsList: [StudentInformation] = []
    
    // MARK: Student Information Struct
    struct StudentInformation {
        
        var createdAt: String? = nil
        var firstName: String? = nil
        var lastName: String? = nil
        var latitude: Double?
        var longitude: Double?
        var mapString: String? = nil
        var mediaURL: String? = nil
        var objectId: String? = nil
        var uniqueKey: String? = nil
        var updatedAt: String? = nil
        
        static var sharedInstance = StudentInformation()
        
        init() {
            self.createdAt = ""
            self.firstName = ""
            self.lastName = ""
            self.latitude = 0.0
            self.longitude = 0.0
            self.mapString = ""
            self.mediaURL = ""
            self.objectId = ""
            self.uniqueKey = ""
            self.updatedAt = ""
        }
        
        init(value: [String:AnyObject]) {
            
            self.createdAt = value[ParseClient.ResponseKeys.CreatedAt] as? String
            self.firstName = value[ParseClient.ResponseKeys.FirstName] as? String ?? ""
            self.lastName = value[ParseClient.ResponseKeys.LastName] as? String ?? ""
            self.latitude = value[ParseClient.ResponseKeys.Latitude] as? Double
            self.longitude = value[ParseClient.ResponseKeys.Longitude] as? Double
            self.mapString = value[ParseClient.ResponseKeys.MapString] as? String
            self.mediaURL = value[ParseClient.ResponseKeys.MediaURL] as? String
            self.objectId = value[ParseClient.ResponseKeys.ObjectID] as? String
            self.uniqueKey = value[ParseClient.ResponseKeys.UniqueKey] as? String
            self.updatedAt = value[ParseClient.ResponseKeys.UpdatedAt] as? String
        }
    }
    
    // MARK: Helper
    static func studentLocationsFromJSON(_ results: [[String:AnyObject]]) -> [StudentInformation] {
        
        var studentLocations = [StudentInformation]()
        var locations = [[String:AnyObject]]()
        var filteredLocation = [String:AnyObject]()
        
        for (_, var location) in results.enumerated() {
            guard let createdAt = location[ParseClient.ResponseKeys.CreatedAt] as? String else {
                continue
            }
            guard let firstName = location[ParseClient.ResponseKeys.FirstName] as? String, firstName != "" else {
                continue
            }
            guard let lastName = location[ParseClient.ResponseKeys.LastName] as? String, lastName != "" else {
                continue
            }
            guard let latitude = location[ParseClient.ResponseKeys.Latitude] as? Double else {
                continue
            }
            guard let longitude = location[ParseClient.ResponseKeys.Longitude] as? Double else {
                continue
            }
            guard let mapString = location[ParseClient.ResponseKeys.MapString] as? String, mapString != "" else {
                continue
            }
            guard let mediaURL = location[ParseClient.ResponseKeys.MediaURL] as? String, mediaURL != "" else {
                continue
            }
            guard let objectId = location[ParseClient.ResponseKeys.ObjectID] as? String else {
                continue
            }
            guard let uniqueKey = location[ParseClient.ResponseKeys.UniqueKey] as? String else {
                continue
            }
            guard let updatedAt = location[ParseClient.ResponseKeys.UpdatedAt] as? String else {
                continue
            }
            if let url = URL(string: mediaURL) {
                if UIApplication.shared.canOpenURL(url) {
                    filteredLocation = [
                        ParseClient.ResponseKeys.CreatedAt:createdAt as AnyObject,
                        ParseClient.ResponseKeys.FirstName:firstName as AnyObject,
                        ParseClient.ResponseKeys.LastName:lastName as AnyObject,
                        ParseClient.ResponseKeys.Latitude:latitude as AnyObject,
                        ParseClient.ResponseKeys.Longitude:longitude as AnyObject,
                        ParseClient.ResponseKeys.MapString:mapString as AnyObject,
                        ParseClient.ResponseKeys.MediaURL:mediaURL as AnyObject,
                        ParseClient.ResponseKeys.ObjectID:objectId as AnyObject,
                        ParseClient.ResponseKeys.UniqueKey:uniqueKey as AnyObject,
                        ParseClient.ResponseKeys.UpdatedAt:updatedAt as AnyObject
                    ]
                    locations.append(filteredLocation)
                }
            }
        }
        for location in locations {
            studentLocations.append(StudentInformation(value: location))
        }
        return studentLocations
    }
    
    static func studentLocationsFromJSON2(_ results: [[String:AnyObject]]) -> [StudentInformation] {
        
        var studentLocations = [StudentInformation]()
        for result in results {
            studentLocations.append(StudentInformation(value: result))
        }
        return studentLocations
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> Student {
        struct Singleton {
            static var sharedInstance = Student()
        }
        return Singleton.sharedInstance
    }
}
