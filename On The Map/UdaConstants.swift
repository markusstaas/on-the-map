//
//  UdaConstants.swift
//  On The Map
//
//  Created by Markus Staas on 7/21/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

extension UdaClient {

struct Constants {
    static let fbAppId = "365362206864879"
    //static let BaseURL = "https://www.udacity.com/api"
    static let ApiScheme = "https"
    static let ApiHost = "www.udacity.com"
    static let ApiPath = "/"
    static let UdacityRegistration = "https://auth.udacity.com/sign-up"
}
struct Methods {
    static let AuthenticationSession = "api/session"
    static let GetUserData = "api/users/<user_id>"
    static let LogoutSessionWithUdacity = "api/session"
}
struct ParameterKeys {
    static let Udacity = "udacity"
    static let Facebook = "facebook_mobile"
    static let AccessToken = "access_token"
    static let UserName = "username"
    static let Password = "password"
}

struct URLKeys {
    static let UserID = "user_id"
}
struct JSONBodyValues {
    static let UserName = ""
    static let Password = ""
}
struct ResponseKeys {
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
