//
//  Device.swift
//  FThisMeetingGamma
//
//  Created by AGW on 6/14/15.
//  Copyright (c) 2015 Andrew Wetherington. All rights reserved.
//

import Foundation
class Device {
    
    var deviceId:String!
    
    init(){
        
    }
    
    func ensureRegistered(){
        if !IOAdapter.doesDeviceFileExist(){ // Doesnt work exactly how you'd think... return value is wonky
            var _deviceId :String? = IOAdapter.getDeviceIdAndWriteFile()
            
            print("deviceId: \(deviceId)")
            if  _deviceId != nil && _deviceId! != "" {
                deviceId = _deviceId
                
            }
            else{
                print("Failed to return valid string from getDeviceIdAndWriteFile. We are offline.")
            }
        }
    }
    
}
