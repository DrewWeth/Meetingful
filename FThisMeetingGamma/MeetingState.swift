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
    public var startingDate:NSDate!
    
    init(people:Int, hourly:Int, startingTime:NSDate){
        peopleCount = people
        hourlyRate = hourly
        startingDate = startingTime
    }
    
    
}