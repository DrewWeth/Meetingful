//
//  Meeting.swift
//  FThisMeetingGamma
//
//  Created by AGW on 6/11/15.
//  Copyright (c) 2015 Andrew Wetherington. All rights reserved.
//
import UIKit

class Meeting {
    var meetingIdentifier:NSString!
    var filename:NSString!
    var logFilename:NSString!
    var cost:Float!
    var name:NSString!
    var email:NSString!
    var worth:Bool!
    var people:Int!
    var timeInSeconds:NSTimeInterval!

    init(){

    }
    
    init(name:String){
        self.name = name
    }
    
    func initializeFiles(){
        meetingIdentifier = randomStringWithLength(6)
        
        filename = createFile(meetingIdentifier)
        logFilename = createLogfile(meetingIdentifier)
    }
    

    func createFile(s:NSString) -> NSString{
        return "\(s).data"
    }
    
    
    
    func createLogfile(s:NSString) -> NSString{
        return "\(s).log"
    }
    
    func save(){
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.arrayOfMeetings.append(self)
        
        IOAdapter.writeArrayOfObjectsToFilepath(delegate.arrayOfMeetings, filepath: delegate.indexFilePath)
        print("Done writing")

        dispatch_async(dispatch_get_main_queue(), {()-> Void in
            var delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if delegate.moreTableController != nil {
                delegate.moreTableController!.tableView.reloadData()
                
            }
        })
        
//        readFromFile(filenameAndPath)
        
    }
    
    func readFromFile(filepath:String){
        var error:NSError?
        var readFile:NSString!
        do{
            
        
        try readFile = NSString(contentsOfFile: filepath, encoding: NSUTF8StringEncoding)
        }catch{
            print(error)
        }
        
//        let readFile:NSString! = NSString(contentsOfFile: filepath, encoding: NSUTF8StringEncoding, error: nil) as? String
        print("readFile::\(readFile)")
    }
    
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    
}