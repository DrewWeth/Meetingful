//
//  MeetingState.swift
//  FThisMeetingGamma
//
//  Created by AGW on 6/11/15.
//  Copyright (c) 2015 Andrew Wetherington. All rights reserved.
//

import Foundation


class MeetingState {
    
    public var peopleCount:Int!
    public var hourlyRate:Int!
    
    init(people:Int, hourly:Int){
        peopleCount = people
        hourlyRate = hourly
    }
    
    
}