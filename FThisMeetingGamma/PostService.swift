//
//  PostService.swift
//  Echo
//
//  Created by AGW on 12/21/14.
//  Copyright (c) 2014 Andrew Wetherington. All rights reserved.
//

import Foundation

class PostService {
    var settings:PostServiceSettings!
    
    init(){
        self.settings = PostServiceSettings()
    }
    
    
    func postDeviceAssignment(callback:(AnyObject)->()) {
        request( settings.baseUrl + settings.assignUrlEnding , method: "get", callback:callback)
    }
    
    func request(url:String, method:String, callback:(AnyObject) -> ()){
        print(url)
        var nsURL = NSURL(string:url)!
        var request = NSMutableURLRequest(URL: nsURL)
        request.HTTPMethod = method
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            // more closure shit that i dont understand
            (data, response, error) in
            var error:NSError?
            var newResponse:AnyObject
            do{
                
                try newResponse = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                callback(newResponse)
            }catch{
                print("Error here")
            }            
        }
        task.resume()
    }
}













