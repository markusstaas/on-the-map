//
//  UdaConstants.swift
//  On The Map
//
//  Created by Markus Staas on 7/21/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

extension UdaClient {
    
    struct Constants {
        static let fbAppId: String = "365362206864879"
        static let BaseURL: String = "https://www.udacity.com/api"
    }
    
    struct ParameterKeys{
        static let Udacity: String = "udacity"
        static let Username: String = "username"
        static let Password: String = "password"
        static let Facebook: String = "facebook_mobile"
        static let AccessToken: String = "access_token"
    }
    
    struct Methods {
        static let Session: String = "session"
        static let UserData: String = "users/{id}"
    }
    
    struct JSONResponseKeys {
        static let Session: String = "session"
        static let SessionID: String = "id"
        static let Account: String = "account"
        static let Key: String = "key"
        static let User: String = "user"
        static let FirstName: String = "nickname"
        static let LastName: String = "last_name"
    }

}
