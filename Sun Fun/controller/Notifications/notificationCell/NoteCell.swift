//
//  NoteCell.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/29/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bigView.RoundCorners(cornerRadius: 10.0)
        bigView.dropShadow()
        message.adjustsFontForContentSizeCategory = true
        date.adjustsFontForContentSizeCategory = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
