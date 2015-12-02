//
//  TimelineTableViewController.swift
//  Securus
//
//  Created by Dominic Bett on 11/30/15.
//  Copyright © 2015 DominicBett. All rights reserved.
//

import UIKit
import Parse

class TimelineTableViewController: UITableViewController {

    var timelineData = NSMutableArray()
    
    func loadData(){
        timelineData.removeAllObjects()
        let findTimelineData:PFQuery = PFQuery(className: "Events")
        findTimelineData.findObjectsInBackgroundWithBlock{
            (events, error)->Void in
            if error == nil{
                for myEvent in events! {
                    let event:PFObject = myEvent as! PFObject
                    self.timelineData.addObject(event)
                }
                let array:NSArray = self.timelineData.reverseObjectEnumerator().allObjects
                self.timelineData = NSMutableArray(array: array)
                
                self.tableView.reloadData()
                
            }
        }
    }
    
    func refresh(sender:AnyObject)
    {
        loadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Refreshing timeline
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Check first if logged in
    override func viewWillAppear(animated: Bool) {
        if (PFUser.currentUser() == nil) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return timelineData.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:TimelineTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TimelineTableViewCell
        
        // Retrieve data
        let event:PFObject = self.timelineData.objectAtIndex(indexPath.row) as! PFObject
        
        // Get username
        let findUser:PFQuery = PFUser.query()!
        //findUser.whereKey("objectId", equalTo: (PFUser.currentUser()?.objectId!)!)
        findUser.whereKey("objectId", equalTo: (event.valueForKey("user")?.objectId)!)
        findUser.findObjectsInBackgroundWithBlock{
            (users, error)->Void in
            if error == nil{
                cell.usernameText.text = users?.last?.username
                

            }
        }
        
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        cell.dateTimeText.text = dateFormatter.stringFromDate(event.createdAt!)
        
        cell.descriptionText.text = event.objectForKey("event") as! String
        
        UIView.animateWithDuration(0.2, animations: {
            cell.usernameText.alpha = 1
            cell.dateTimeText.alpha = 1
            cell.descriptionText.alpha = 1
        })
        
        // Configure the cell...
    
        return cell
    }
    
    
    @IBAction func postEvent(sender: AnyObject) {
        self.performSegueWithIdentifier("compose", sender: self)
    }
    
    @IBAction func logout(sender: AnyObject) {
        // Create the alert controller to confirm logout
        let alertController = UIAlertController(title: "Confirm logout", message: "Are you sure you want to logout?", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            // Send a request to log out a user
            PFUser.logOut()
            // Navigate to the Login Screen
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
            print("Logged out!")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            print("Logout Dismissed!")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Allow next screen (create/post event) to navigate back to this screen
    @IBAction func unwindToTimelineScreen(segue:UIStoryboardSegue) {
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}