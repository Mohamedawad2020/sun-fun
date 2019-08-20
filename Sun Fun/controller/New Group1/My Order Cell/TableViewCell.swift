//
//  TableViewCell.swift
//  Sun Fun
//
//  Created by arab devolpers on 8/3/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var imageOrder: UIImageView!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var ticketNumberLB: UILabel!
    @IBOutlet weak var priceLB: UILabel!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var bottomview: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageOrder.roundCorners(cornerRadius: 10.0)
        topView.RoundCorners(cornerRadius: 10.0)
        viewButton.roundCorners(cornerRadius: 5.0)
        viewButton.setBorder()
        bottomview.roundBottomCorners(cornerRadius: 10.0)
        topView.dropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
