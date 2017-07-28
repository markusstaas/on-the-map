//
//  ListViewController.swift
//  On The Map
//
//  Created by Markus Staas on 7/24/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    
    @IBOutlet var detailTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.automaticallyAdjustsScrollViewInsets = false
        getLocationsForTableView()

        
    }
    override func viewDidAppear(_ animated: Bool) {
        Helper.areWeOnline()
    }
    
    @IBAction func refreshView(_ sender: Any) {
        Helper.areWeOnline()
        getLocationsForTableView()
       
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        LoadingIndicator.sharedInstance().startIndicator(self)
        UdaClient.sharedInstance().logoutSessionWithUdacity(){(success, errorString) in
            
            performUIUpdatesOnMain {
                LoadingIndicator.sharedInstance().stopIndicator(self)
                if success{
                    self.dismiss(animated: true, completion: nil)
                } else {
                    Helper.showErrorAlert(message: errorString!)
                }
            }
        }
    }
    
    func getLocationsForTableView(){
        
        LoadingIndicator.sharedInstance().startIndicator(self)
        ParseClient.sharedInstance().getStudentLocations() {
            (success, results, errorString) in
            
            performUIUpdatesOnMain {
                LoadingIndicator.sharedInstance().stopIndicator(self)
                guard (success == true) else {
                    Helper.showErrorAlert(message: errorString!)
                    return
                }
                guard (results != nil) else {
                   Helper.showErrorAlert(message: errorString!)
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
