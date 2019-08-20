//
//  MyActivityCel.swift
//  Sun Fun
//
//  Created by arab devolpers on 8/4/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit

class MyActivityCel: UITableViewCell {

    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var subscribNumber: UILabel!
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var activityNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        activityImage.roundCorners(cornerRadius: 10.0)
        subscribNumber.adjustsFontForContentSizeCategory = true
        activityName.adjustsFontForContentSizeCategory = true
        activityNumber.adjustsFontForContentSizeCategory = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
