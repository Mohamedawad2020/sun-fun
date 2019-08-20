//
//  eventCell.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/17/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit

class eventCell: UITableViewCell {


    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var imageEvent: UIImageView!
    
    
    @IBOutlet weak var ticketRemaining: UILabel!
    @IBOutlet weak var joinUsNumber: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var bookBTN: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.RoundCorners(cornerRadius: 10.0)
        dateView.circleView()
       dateLable.adjustsFontForContentSizeCategory = true
        //nameView.RoundCorners(cornerRadius: 10.0)

        ticketRemaining.adjustsFontForContentSizeCategory = true
        joinUsNumber.adjustsFontForContentSizeCategory = true
        price.adjustsFontForContentSizeCategory = true
        eventName.adjustsFontForContentSizeCategory = true
        cellView.dropShadow()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func book_now_Btn(_ sender: Any) {
       
    }
}
