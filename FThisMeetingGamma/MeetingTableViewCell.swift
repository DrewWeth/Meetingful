//
//  MeetingTableViewCell.swift
//  FThisMeetingGamma
//
//  Created by AGW on 6/12/15.
//  Copyright (c) 2015 Andrew Wetherington. All rights reserved.
//

import UIKit

class MeetingTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func animate(){
        let view = self.contentView
        view.layer.opacity = 0.0
        UIView.animateWithDuration(0.1, animations: {
            view.layer.opacity = 1
        })
        
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
