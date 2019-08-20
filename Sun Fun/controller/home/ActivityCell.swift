//
//  ActivityCell.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/23/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit

class ActivityCell: UICollectionViewCell {
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var viewC: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
       viewC.dropShadow()
    }

}
