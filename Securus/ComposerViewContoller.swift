//
//  TimelineViewController.swift
//  Securus
//
//  Created by Dominic Bett on 11/16/15.
//  Copyright © 2015 DominicBett. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class ComposerViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    var placeholderLabel : UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var locValue: CLLocationCoordinate2D! = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Authorize and update location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            print("Location Status Not Authorized")
            let alert = UIAlertView(title: "Location Services Required", message: "Go to Settings > Securus > Locations > When Using the App to enable location services", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        
        
        // Retrieving the location co-ordinate
        // let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        // Do reverseGeocodeLocation to get name of city, zip-code etc...
        
        
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
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locValue = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Couldn't get your location")
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
    
    @IBAction func postEvent(sender: AnyObject) {
        if descriptionTextView.text.isEmpty {
            let alert = UIAlertView(title: "Invalid Description", message: "Please write a short description....", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }else{
            let event:PFObject = PFObject(className: "Events")
            event["user"] = PFUser.currentUser()
            event["event"] = descriptionTextView.text
            if locValue != nil {
                locationManager.stopUpdatingLocation()
                event["longitude"] = locValue!.longitude as Double
                event["latitude"] = locValue!.latitude as Double
            }
            event.saveInBackground()
        
            dismissViewControllerAnimated(true, completion: nil)
            //self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
}
