//
//  BankCell.swift
//  Sun Fun
//
//  Created by arab devolpers on 8/6/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit

class BankCell: UITableViewCell {

    @IBOutlet weak var bankView: UIView!
    @IBOutlet weak var accountNumber: UILabel!
    @IBOutlet weak var accountBankName: UILabel!
    @IBOutlet weak var accountIBAN: UILabel!
    @IBOutlet weak var accountName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        bankView.RoundCorners(cornerRadius: 10.0)
        accountNumber.adjustsFontForContentSizeCategory = true
        accountIBAN.adjustsFontForContentSizeCategory = true
        accountName.adjustsFontForContentSizeCategory = true
        accountBankName.adjustsFontForContentSizeCategory = true
        bankView.dropShadow()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
