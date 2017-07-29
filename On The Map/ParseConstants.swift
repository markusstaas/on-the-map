//
//  ParseConstants.swift
//  On The Map
//
//  Created by Markus Staas on 7/26/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

extension ParseClient {

    struct Constants {
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/"
    }

    struct Methods {
        static let GetStudentLocations = "parse/classes/StudentLocation"
        static let GetStudentLocation = "parse/classes/StudentLocation"
        static let PostStudentLocation = "parse/classes/StudentLocation"
        static let PutStudentLocation = "parse/classes/StudentLocation/<objectId>"
    }
    struct ParameterKeys {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        static let Where = "where"
    }

    struct ParameterValues {
        static let Limit = "100"
        static let Order = "-updatedAt"
    }

    struct ResponseKeys {
        static let Results = "results"
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
    }
}

