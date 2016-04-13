//
//  MoreTableViewController.swift
//  FThisMeetingGamma
//
//  Created by AGW on 6/12/15.
//  Copyright (c) 2015 Andrew Wetherington. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {
    
    
    var appDelegate:AppDelegate!
    var meetingArray:Array<Meeting>!
    var historyDisplayCount :Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MoreTable viewDidLoad")

        
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.meetingArray = appDelegate.arrayOfMeetings
        appDelegate.moreTableController = self
        print("more \(self.meetingArray.count)")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 { // stats
            return 2
        }
        else if section == 1{
            if appDelegate.arrayOfMeetings.count <= 5 {
                historyDisplayCount = appDelegate.arrayOfMeetings.count
//                return appDelegate.arrayOfMeetings.count

            }
            else{
                historyDisplayCount = 5
//                return 5

            }
            return appDelegate.arrayOfMeetings.count
        }
        else if section == 2{
            return 3
        }
        
        
        return 0
    }
    
    func giveMeHeader(title:String)-> UIView{
        var newView = UIView(frame: CGRect(x: 20.0, y: 0.0, width: self.view.frame.width, height: 100.0))
        var newLabel = UILabel(frame: CGRect(x: 20.0, y: 0.0, width: self.view.frame.width, height: 42.0))
        newLabel.text = title
        newView.addSubview(newLabel)
        return newView
    }

    
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 {
//            return giveMeHeader("Stats")
//        }
//        else if section == 1 {
//            return giveMeHeader("History")
//        }
//        else{
//            return giveMeHeader("Error")
//        }
//    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Stats"
            
        }
        else if section == 1{
            if appDelegate.arrayOfMeetings.count > 0{
                
                return "Meeting History (\(appDelegate.arrayOfMeetings.count))"
            }else{
                return "Meeting History"
            }
        }
        else if section == 2{
            return "Settings"
        }
        return nil
    }
    
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("statsCell") as! StatsTableViewCell
            if indexPath.row == 0{
                cell.statsTime.text = "Total time"
                cell.statsCost.text = totalMeetingsTime().time
            }
            else {
                cell.statsTime.text = "Total cost"
                cell.statsCost.text = String(format: "$%.2f", totalMeetingsCost())

            }

            return cell
        }
        else if indexPath.section == 1{
            let cell:StatsTableViewCell = tableView.dequeueReusableCellWithIdentifier("statsCell") as! StatsTableViewCell
//                if indexPath.row != historyDisplayCount
//                {
            var meeting = appDelegate.arrayOfMeetings[appDelegate.arrayOfMeetings.count - 1 - indexPath.row]
                    cell.statsTime.text = "\(meeting.timeInSeconds.time)"
                    print("Meeting cost: \(meeting.cost)")
                    cell.statsCost.text = "\(String(format: "$%0.2f", meeting.cost))" ?? "None"
                    cell.animate()

                    
//                }
//                else{
//                    cell.timeLabel.text = "More..."
//                    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//                    cell.costLabel.hidden = true
//
//                }
            return cell
        }
        else if indexPath.section == 2{
            let cell:MeetingTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! MeetingTableViewCell
            if indexPath.row == 0 {
            
            
                cell.timeLabel.text = "Reset History"
            }
            else if indexPath.row == 1 {
                cell.timeLabel.text = "Sign In"
            }
            else if indexPath.row == 2{
                cell.timeLabel.text = "Device ID: \(appDelegate.device.deviceId)"
            }

            cell.costLabel.hidden = true
//            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

            return cell
        }
        
        return MeetingTableViewCell()
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1{
            if indexPath.row == historyDisplayCount{
                historyDisplayCount = historyDisplayCount + 1
                reloadTable()
                
            }
        }
        else if indexPath.section == 2{
            if indexPath.row == 0{
                if confirmReset(){
                    reloadTable()
                }
            }
        }
        
    }
    
    func reloadTable(){
        dispatch_async(dispatch_get_main_queue(), {()-> Void in
            var delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if delegate.moreTableController != nil {
                delegate.moreTableController!.tableView.reloadData()
            }
        })
    }
    
    func confirmReset() -> Bool{
        var alert = UIAlertController(title: "Reset Meeting History?", message: "Are you sure you want to delete your meetings?", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: {
            action in
            
            print("chose yes")
            self.appDelegate.arrayOfMeetings = []
            self.dismissViewControllerAnimated(true, completion: {})
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:{
            action in

            self.dismissViewControllerAnimated(true, completion: {})
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        return true
    }
    
    
    func totalMeetingsCost() -> Double{
        var total : Double = 0.0
        for meeting in appDelegate.arrayOfMeetings {
            total = total + Double(meeting.cost)
        }
        return total
    }
    
    func totalMeetingsTime() -> NSTimeInterval {
        var total : NSTimeInterval = 0
        for meeting in appDelegate.arrayOfMeetings{
            total = total + meeting.timeInSeconds
        }
        
        return total
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
