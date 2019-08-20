//
//  MyCell.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/30/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {
    @IBOutlet weak var toTime: UILabel!
    @IBOutlet weak var fromTime: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventOrganizer: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var imageEvent: UIImageView!
    
    @IBOutlet weak var myCellView: UIView!
    @IBOutlet weak var bookBTN: UIButton!
    @IBOutlet weak var removeBTN: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        toTime.adjustsFontForContentSizeCategory = true
        fromTime.adjustsFontForContentSizeCategory = true
        eventDate.adjustsFontForContentSizeCategory = true
        eventDescription.adjustsFontForContentSizeCategory = true
        eventOrganizer.adjustsFontForContentSizeCategory = true
        eventName.adjustsFontForContentSizeCategory = true
        
        bookBTN.roundCorners(cornerRadius: 5.0)
        removeBTN.roundCorners(cornerRadius: 5.0)
        imageEvent.roundCorners(cornerRadius: 10.0)
        myCellView.dropShadow()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
