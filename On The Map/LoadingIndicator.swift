//
//  LoadingIndicator.swift
//  On The Map
//
//  Created by Markus Staas on 7/25/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import Foundation
import UIKit

// MARK: ActivityIndicator

class LoadingIndicator {
    
    private var container = UIView()
    private var loadingView = UIView()
    private var indicator = UIActivityIndicatorView()
    
    func startIndicator(_ hostViewController: UIViewController) {
        
        container.tag = 100
        container.frame = hostViewController.view.frame
        container.center = hostViewController.view.center
        container.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.6)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = hostViewController.view.center
        loadingView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        indicator.hidesWhenStopped = true
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        indicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        
        loadingView.addSubview(indicator)
        container.addSubview(loadingView)
        indicator.startAnimating()
        hostViewController.view.addSubview(container)
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopIndicator(_ hostViewController: UIViewController) {
        indicator.stopAnimating()
        hostViewController.view.viewWithTag(100)?.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> LoadingIndicator {
        struct Singleton {
            static var sharedInstance = LoadingIndicator()
        }
        return Singleton.sharedInstance
    }
}
