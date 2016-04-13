//
//  IOAdapter.swift
//  FThisMeetingGamma
//
//  Created by AGW on 6/12/15.
//  Copyright (c) 2015 Andrew Wetherington. All rights reserved.
//
import UIKit

import Foundation
class IOAdapter{
    
    
    static func fetchArrayOfObjectsFromFilepath(filepath:String)-> [Meeting]{
        var anyObj:NSArray?
        
        let inputStream = NSInputStream(fileAtPath: filepath)
        inputStream?.open()
        do{
            try anyObj = (NSJSONSerialization.JSONObjectWithStream( inputStream!, options: [NSJSONReadingOptions.MutableContainers]) as? NSArray)!
        }catch{
            print("Error in parsing JSON, returning empty Meeting array")
            anyObj = [Meeting]()
        }
        inputStream?.close()
        
        var arrayOfMeetings = [Meeting]()
        if anyObj != nil {
            for jsonObj in anyObj!{
                if let json = jsonObj as? NSDictionary{
                    print("\(json.allKeys) \(json.allValues)")
                    let b :Meeting = Meeting()
                    b.name = (json["Name"] as? NSString) ?? "NAME"
                    if let worth = json["Worth"] as? NSString{
                        if worth == "true"{
                            b.worth = true
                        }else{
                            b.worth = false
                        }
                    }
                    let cost = json["Cost"] as? NSString
                    b.cost = cost!.floatValue ?? 0.0
                    let tis = json["TimeInSeconds"] as? NSString
                    b.timeInSeconds = tis!.doubleValue
                    arrayOfMeetings.append(b)
                    print("b.cost: \(b.cost)")
                }else{
                    print("Cannot convert to dictionary")
                }
            }
        }else{
            print("Error: anyObj is not NSArray")
        }
        print("Fetched array size: \(arrayOfMeetings.count)")
        return arrayOfMeetings
    }
    
    static func writeArrayOfObjectsToFilepath(arrayOfObjects:Array<Meeting>, filepath:String) -> Bool{
        
//        var jsonString = "["
//        for obj in arrayOfObjects{
//            jsonString = jsonString + (obj.toJsonString() as String)
//            if arrayOfObjects.last != obj{
//                jsonString = jsonString + ","
//            }
//        }
//        jsonString = jsonString + "]"
        
        
        print("About to make array stuff")
        
        var arr:NSMutableArray = []
        for meeting in arrayOfObjects{
            
            let dict:NSDictionary = [ "Name": "Default",
                                            "Worth":  "\(meeting.worth)",
                                            "Cost": "\(meeting.cost)",
                                            "TimeInSeconds": "\(meeting.timeInSeconds)"
            ]
            print(dict)
            arr.addObject(dict)
        }
        
        if NSJSONSerialization.isValidJSONObject(NSArray(array:arr)){
            var error:NSError?
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let outputStream = NSOutputStream(toFileAtPath: delegate.indexFilePath, append: false)
            outputStream?.open()
            NSJSONSerialization.writeJSONObject(NSArray(array:arr), toStream: outputStream!, options:[], error: &error)
            outputStream?.close()
            if (error != nil){
                print("An error has occured: \(error?.localizedDescription)")
            }
        }else{
            print("Error in writing")
            return false
        }
        
//        do{
//            print("About to write array")
//            let data = try NSJSONSerialization.dataWithJSONObject(arr, options: [])
//            try data.writeToFile(delegate.indexFilePath, options:[])
//            
//            
//            
//        }catch{
//            print("error 43871")
//        }
        
        return true
    }
    
    static func doesDeviceFileExist()->Bool{
        var DEVICE_FILENAME = "DEVICE.DATA"
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var pathAndFilename = "\(appDelegate.documentDirectory)/\(DEVICE_FILENAME)"
        
        if (NSFileManager.defaultManager().fileExistsAtPath(pathAndFilename))
        {
            print("DEVICE.DATA file exists (\(pathAndFilename)). Continuing...")
            return true
        }
        else{
            return false
        }
    }
    
    
    static func getDeviceIdAndWriteFile() -> String {
        
        var ps = PostService()
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var deviceId:String? = ""
        
        ps.postDeviceAssignment({
            callback in

            var hash = callback as! NSDictionary
            var result = hash["result"] as! String
            
            if result == "success" {
                var data = hash["data"] as! NSDictionary
                
                deviceId = (data["device_id"] as? String?) ?? "badDeviceId"
                var createdAt = (data["created_at"] as? String?) ?? ""
                
                
                var hashAsString:String = "{ \"device_id\":\"\(deviceId!)\", \"created_at\":\"\(createdAt!)\" }"
                print(hashAsString)
                
                var error:NSError?
                do{
                    
                    try hashAsString.writeToFile(appDelegate.documentDirectory + "/DEVICE.DATA", atomically: false, encoding: NSUTF8StringEncoding)
                }catch{
                    print("error 78371")
                }
                print("Device writing error \(error)")
            }
            else{
                print("API result != success")
            }
        })
        print("DeviceID! (\(deviceId!))")
        
        return deviceId!
    }
}