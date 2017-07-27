//
//  ListViewController.swift
//  On The Map
//
//  Created by Markus Staas on 7/24/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit
import ReachabilitySwift

class ListViewController: UITableViewController {
    
    
    @IBOutlet var detailTableView: UITableView!
    let reachability = Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.automaticallyAdjustsScrollViewInsets = false
        getLocationsForTableView()

        // Do any additional setup after loading the view.
    }
    
    func areWeOnline() -> Bool{
        if (reachability?.isReachable)! {
            return true
        }else{
            showErrorAlert(message: "Could not connect to the Internet, please connect to the Internet to use this app")
            return false
        }
    }
    
    func showErrorAlert(message: String, dismissButtonTitle: String = "Cool") {
        let controller = UIAlertController(title: "Error Message:", message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: dismissButtonTitle, style: .default) { (action: UIAlertAction!) in
            controller.dismiss(animated: true, completion: nil)
        })
        
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: Map Functions For Table
    
    func getLocationsForTableView(){
        
        LoadingIndicator.sharedInstance().startIndicator(self)
        ParseClient.sharedInstance().getStudentLocations() {
            (success, results, errorString) in
            
            performUIUpdatesOnMain {
                LoadingIndicator.sharedInstance().stopIndicator(self)
                guard (success == true) else {
                    self.showErrorAlert(message: errorString!)
                    return
                }
                guard (results != nil) else {
                   self.showErrorAlert(message: errorString!)
                    return
                }
                self.detailTableView.reloadData()
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let completeSet = Student.sharedInstance().studentLocationsList
        return completeSet.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = Student.sharedInstance().studentLocationsList[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentDetail", for: indexPath)
        let image = UIImage(named: "icon_pin")
        cell.textLabel?.text = "\(student.firstName!) \(student.lastName!)"
        cell.imageView?.image = image
        cell.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = Student.sharedInstance().studentLocationsList[(indexPath as NSIndexPath).row]
        let browser = UIApplication.shared
        if let url = URL(string: student.linkURL!) {
            browser.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
}
