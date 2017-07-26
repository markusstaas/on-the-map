//
//  UdaConstants.swift
//  On The Map
//
//  Created by Markus Staas on 7/21/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

extension UdaClient {

struct Constants {
    static let ApiScheme = "https"
    static let ApiHost = "www.udacity.com"
    static let ApiPath = "/"
    static let SignUpUdacity = "https://www.udacity.com/account/auth#!/signup"
    static let fbAppId = "365362206864879"
    static let BaseURL = "https://www.udacity.com/api"
}


struct Headers {
    static let XSRF = "X-XSRF-TOKEN"
}


struct Methods {
    static let AuthenticationSessionNew = "api/session"
    static let GetPublicUserData = "api/users/<user_id>"
    static let LogoutSessionWithUdacity = "api/session"
}

// WAS CALLED: JSON Body Keys
struct ParameterKeys {
    
    static let Udacity = "udacity"
    static let Facebook = "facebook_mobile"
    static let AccessToken = "access_token"
    static let UserName = "username"
    static let Password = "password"
}

// MARK: URL Keys
struct URLKeys {
    static let UserID = "user_id"
}

// MARK: JSON Body Values
struct JSONBodyValues {
    
    static let UserName = ""
    static let Password = ""
}

// MARK: JSON Response Keys
struct JSONResponseKeys {
    
    static let FirstName = "first_name"
    static let LastName = "last_name"
    static let User = "user"
    static let Account = "account"
    static let Registered = "registered"
    static let Key = "key"
    static let Session = "session"
    static let ID = "id"
    static let Expiration = "expiration"
}
}
