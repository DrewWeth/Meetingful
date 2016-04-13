//
//  StatsTableViewCell.swift
//  FThisMeetingGamma
//
//  Created by AGW on 6/14/15.
//  Copyright (c) 2015 Andrew Wetherington. All rights reserved.
//

import UIKit

class StatsTableViewCell: UITableViewCell {

    @IBOutlet weak var statsTime: UILabel!
    @IBOutlet weak var statsCost: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func animate(){
        let view = self.contentView
        view.layer.opacity = 0.0
        UIView.animateWithDuration(0.1, animations: {
            view.layer.opacity = 1
        })
        
    }

}
