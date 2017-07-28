//
//  Helper.swift
//  On The Map
//
//  Created by Markus Staas on 7/28/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import Foundation
import ReachabilitySwift


class Helper{
    
    static func areWeOnline() {
        let reachability = Reachability()
        if !(reachability?.isReachable)! {
           showErrorAlert(message: "Could not connect to the Internet, please connect to the Internet to use this app")
            return
        }
    }

    static func showErrorAlert(message: String, dismissButtonTitle: String = "Cool") {
        let controller = UIAlertController(title: "Error Message:", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: dismissButtonTitle, style: .default) { (action: UIAlertAction!) in
            controller.dismiss(animated: true, completion: nil)
        })
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(controller, animated: true, completion: nil)
    }

    // MARK: Shared Instance
    class func sharedInstance() -> Helper {
        struct Singleton {
            static var sharedInstance = Helper()
        }
        return Singleton.sharedInstance
    }
}
