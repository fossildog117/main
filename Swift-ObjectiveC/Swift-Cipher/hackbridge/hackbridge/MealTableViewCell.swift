//
//  Menu.swift
//  hackbridge
//
//  Created by Nathan Liu on 30/01/2016.
//  Copyright © 2016 Liu Empire. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    
    let cellIdentifier = "cell"

    @IBOutlet var candidate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
