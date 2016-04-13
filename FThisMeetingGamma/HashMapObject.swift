//
//  HashMapObject.swift
//  FThisMeetingGamma
//
//  Created by AGW on 6/14/15.
//  Copyright (c) 2015 Andrew Wetherington. All rights reserved.
//

import Foundation
class HashMapObject:Serializable{
    var hashObj :NSDictionary!

    init(hash:NSDictionary){
        
        self.hashObj = hash
    }
}