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
    var dateFormatter:NSDateFormatter = NSDateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
//        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateFormat = "MM/dd hh:mm a"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        print("MoreTable viewDidLoad")
        
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.meetingArray = appDelegate.arrayOfMeetings
        appDelegate.moreTableController = self
        self.tableView.allowsMultipleSelection = false
        
        
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 1{
            return true
        }else{
            return false
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            appDelegate.arrayOfMeetings.removeAtIndex(appDelegate.arrayOfMeetings.count - indexPath.row - 1)
            IOAdapter.writeArrayOfObjectsToFilepath(self.appDelegate.arrayOfMeetings, filepath: self.appDelegate.indexFilePath)
            self.reloadTable()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 { // stats
            return 2
        }
        else if section == 1{
            if appDelegate.arrayOfMeetings.count == 0{
                return 1
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
    
    func determineHumanDuration(ti:NSTimeInterval)-> String{
        
        let minutes = ti/60.0
        let seconds = round(ti - floor(minutes) * 60)

        if floor(minutes) > 0 {
            return "\(NSString(format: "%0.2f", minutes)) mins"
            
        }else{
            return "\(seconds) secs"
        }
        
        
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
            if appDelegate.arrayOfMeetings.count > 0{
                let meeting = appDelegate.arrayOfMeetings[appDelegate.arrayOfMeetings.count - 1 - indexPath.row]
        
                cell.statsTime.text = "\(dateFormatter.stringFromDate(meeting.startDate)) | \(determineHumanDuration(meeting.timeInSeconds))"
                cell.statsCost.text = "\(String(format: "$%0.2f", meeting.cost))" ?? "None"
                cell.animate()
            }else{
                cell.statsTime.text = "No meeting history"
                cell.statsCost.text = ""
                cell.animate()
            }
            return cell
        }
        else if indexPath.section == 2{
            let cell:MeetingTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! MeetingTableViewCell
            if indexPath.row == 0 {
                cell.timeLabel.text = "Reset History"
            }else if(indexPath.row == 1){
                cell.timeLabel.text = "Review This App"
            }else if(indexPath.row == 2){
                cell.timeLabel.text = "Visit Meetingful Website"
            }
//            else if indexPath.row == 1 {
//                cell.timeLabel.text = "Sign In"
//            }
//            else if indexPath.row == 2{
//                cell.timeLabel.text = "Device ID: \(appDelegate.device.deviceId)"
//            }

            cell.costLabel.hidden = true
//            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

            return cell
        }
        
        return MeetingTableViewCell()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 60
        }else{
            return 30
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2{
            if indexPath.row == 0{
                confirmReset()
            }else if indexPath.row == 1{
                
                UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/id1063168303")!);

            }else if indexPath.row == 2{
                UIApplication.sharedApplication().openURL(NSURL(string : "http://meetingful.github.io/")!);
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
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2{
            return 100.0
        }
        return 0
    }
    
    func confirmReset() -> Bool{
        var alert = UIAlertController(title: "Reset Meeting History?", message: "Are you sure you want to delete your meetings?", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: {
            action in
            
            self.appDelegate.arrayOfMeetings = []
            IOAdapter.writeArrayOfObjectsToFilepath(self.appDelegate.arrayOfMeetings, filepath: self.appDelegate.indexFilePath)
            self.reloadTable()
            
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

}
