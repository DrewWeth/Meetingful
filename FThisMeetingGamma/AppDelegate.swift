//
//  AppDelegate.swift
//  FThisMeetingGamma
//
//  Created by AGW on 6/9/15.
//  Copyright (c) 2015 Andrew Wetherington. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var arrayOfMeetings = [Meeting]()
    var documentDirectory:String!
    var indexFilePath :String!
    var moreTableController:UITableViewController?
    var device : Device!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        var paths :NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        self.documentDirectory = paths.objectAtIndex(0) as! String
        indexFilePath = "\(documentDirectory)/INDEX.DATA"
        var filenameAndPath = indexFilePath
        
        if (NSFileManager.defaultManager().fileExistsAtPath(filenameAndPath))
        {
            print("INDEX.DATA file exists (\(filenameAndPath)). Continuing...")

            arrayOfMeetings = IOAdapter.fetchArrayOfObjectsFromFilepath(filenameAndPath)
        }
        else{
            var emptyText = ""
            var error:NSError?
            do{
                try emptyText.writeToFile(indexFilePath, atomically: false, encoding: NSUTF8StringEncoding)
            }catch{
                print("error 1112")
            }
            print("initial error \(error)")
            arrayOfMeetings = IOAdapter.fetchArrayOfObjectsFromFilepath(filenameAndPath)
        }
        
        self.device = Device()
//        self.device.ensureRegistered()

        print("Done with registering")
        return true
    }

    func getArrayOfMeetings() -> [Meeting]{
        print("arr of meetings")
        return self.arrayOfMeetings
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

