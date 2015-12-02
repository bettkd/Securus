//
//  TimelineViewController.swift
//  Securus
//
//  Created by Dominic Bett on 11/16/15.
//  Copyright © 2015 DominicBett. All rights reserved.
//

import UIKit
import Parse
//import CoreLocation

class ComposerViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    var placeholderLabel : UILabel!
    
    @IBOutlet weak var remainingLabel: UILabel!
    
    
    /*let locationManager = CLLocationManager()
    var locValue: CLLocation!*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request Location from User
        /*locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()*/
        
        // Show the current visitor's username
        if let pUserName = PFUser.currentUser()?["username"] as? String {
            self.userNameLabel.text = "@" + pUserName
        }
        
        // Format the text box
        descriptionTextView.layer.borderColor = UIColor.blackColor().CGColor
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.cornerRadius = 5
        
        // Add placeholder text on the descriptions text view
        descriptionTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Describe briefly the event..."
        placeholderLabel.sizeToFit()
        descriptionTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPointMake(5, descriptionTextView.font!.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.hidden = !descriptionTextView.text.isEmpty
    }
    
    // Make placeholder text disappear from description text view
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = !textView.text.isEmpty
    }
    
    // Decrement remaining character counter
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newLength: Int = (descriptionTextView.text as NSString).length + (text as NSString).length - range.length
        let remainder: Int = 200 - newLength
        
        remainingLabel.text = "\(remainder)"
        
        return (newLength >= 200) ? false : true
    }
    
    //Dismiss keyboard when touch outside -> resign first responder when textview is not touched
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if (PFUser.currentUser() == nil) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
        }
    }
    
    /*
    //Get the current location
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    locationManager.startUpdatingLocation()
                    locValue = self.locationManager.location
                }
            }
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locValue = location
            locationManager.stopUpdatingLocation()
            print("locations = \(locValue.coordinate.latitude) \(locValue.coordinate.longitude)", terminator: "\n")
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }*/
    
    @IBAction func postEvent(sender: AnyObject) {
        if descriptionTextView.text.isEmpty {
            let alert = UIAlertView(title: "Invalid Description", message: "Please write a short description....", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }else{
            let event:PFObject = PFObject(className: "Events")
            event["user"] = PFUser.currentUser()
            event["event"] = descriptionTextView.text
            /*event["longitude"] = locValue.coordinate.longitude
            event["latitude"] = locValue.coordinate.latitude*/
            event.saveInBackground()
        
            dismissViewControllerAnimated(true, completion: nil)
            //self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
}
