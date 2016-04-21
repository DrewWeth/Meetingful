//
//  SecondViewController.swift
//  FThisMeetingGamma
//
//  Created by AGW on 6/9/15.
//  Copyright (c) 2015 Andrew Wetherington. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    
    @IBOutlet var ScrollView : UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScrollView.contentSize.height = 1000
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

