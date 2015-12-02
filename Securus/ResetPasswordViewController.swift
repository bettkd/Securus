//
//  TimelineViewController.swift
//  Securus
//
//  Created by Dominic Bett on 11/16/15.
//  Copyright © 2015 DominicBett. All rights reserved.
//

import UIKit
import Parse

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailField.delegate = self
        // Do any additional setup after loading the view.
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
    
    @IBAction func passwordReset(sender: AnyObject) {
        let email = self.emailField.text?.lowercaseString
        let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        // Send a request to reset a password
        PFUser.requestPasswordResetForEmailInBackground(finalEmail)
        
        let alert = UIAlertController (title: "Password Reset", message: "An email containing information on how to reset your password has been sent to " + finalEmail + ".", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        passwordReset(self)
        return true
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
