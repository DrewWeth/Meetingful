//
//  BaseTabBarController.swift
//  FThisMeetingGamma
//
//  Created by AGW on 6/11/15.
//  Copyright (c) 2015 Andrew Wetherington. All rights reserved.
//


import UIKit

class BaseTabBarController: UITabBarController {
    
    @IBInspectable var defaultIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
    }
    
    
    
    
}