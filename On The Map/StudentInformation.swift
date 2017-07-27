//
//  StudentInformation.swift
//  On The Map
//
//  Created by Markus Staas on 7/26/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import Foundation
import UIKit


class Student {

    var studentLocationsList: [StudentInformation] = []
    struct StudentInformation {
        var firstName: String? = nil
        var lastName: String? = nil
        var latitude: Double?
        var longitude: Double?
        var mapString: String? = nil
        var linkURL: String? = nil
        var objectId: String? = nil
        var uniqueKey: String? = nil
        var updatedAt: String? = nil
        var createdAt: String? = nil
        
        static var sharedInstance = StudentInformation()
        
        init() {
            self.firstName = ""
            self.lastName = ""
            self.latitude = 0.0
            self.longitude = 0.0
            self.mapString = ""
            self.linkURL = ""
            self.objectId = ""
            self.uniqueKey = ""
            self.updatedAt = ""
            self.createdAt = ""
        }
        
        init(value: [String:AnyObject]) {

            self.firstName = value[ParseClient.ResponseKeys.FirstName] as? String ?? ""
            self.lastName = value[ParseClient.ResponseKeys.LastName] as? String ?? ""
            self.latitude = value[ParseClient.ResponseKeys.Latitude] as? Double
            self.longitude = value[ParseClient.ResponseKeys.Longitude] as? Double
            self.mapString = value[ParseClient.ResponseKeys.MapString] as? String
            self.linkURL = value[ParseClient.ResponseKeys.MediaURL] as? String
            self.objectId = value[ParseClient.ResponseKeys.ObjectID] as? String
            self.uniqueKey = value[ParseClient.ResponseKeys.UniqueKey] as? String
            self.updatedAt = value[ParseClient.ResponseKeys.UpdatedAt] as? String
            self.createdAt = value[ParseClient.ResponseKeys.CreatedAt] as? String
        }
    }
    
    
static func studentInformationFromData(_ results: [[String:AnyObject]]) -> [StudentInformation] {
        
        var studentLocations = [StudentInformation]()
        var locationDetails = [[String:AnyObject]]()
        var sortedLocation = [String:AnyObject]()
        
        for (_, var location) in results.enumerated() {
           
            guard let firstName = location[ParseClient.ResponseKeys.FirstName] as? String, firstName != "" else { continue }
            guard let lastName = location[ParseClient.ResponseKeys.LastName] as? String, lastName != "" else { continue }
            guard let latitude = location[ParseClient.ResponseKeys.Latitude] as? Double else { continue }
            guard let longitude = location[ParseClient.ResponseKeys.Longitude] as? Double else { continue }
            guard let mapString = location[ParseClient.ResponseKeys.MapString] as? String, mapString != "" else { continue }
            guard let mediaURL = location[ParseClient.ResponseKeys.MediaURL] as? String, mediaURL != "" else { continue }
            guard let objectId = location[ParseClient.ResponseKeys.ObjectID] as? String else { continue }
            guard let uniqueKey = location[ParseClient.ResponseKeys.UniqueKey] as? String else { continue }
            guard let updatedAt = location[ParseClient.ResponseKeys.UpdatedAt] as? String else { continue }
            guard let createdAt = location[ParseClient.ResponseKeys.CreatedAt] as? String else { continue }
            if let url = URL(string: mediaURL) {
                if UIApplication.shared.canOpenURL(url) {
                    sortedLocation = [
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
                    locationDetails.append(sortedLocation)
                }
            }}
    for location in locationDetails {
            studentLocations.append(StudentInformation(value: location))
        }
        return studentLocations
    }
    class func sharedInstance() -> Student {
        struct Singleton {
            static var sharedInstance = Student()
        }
        return Singleton.sharedInstance
    }
}
