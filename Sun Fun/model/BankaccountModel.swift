//
//  BankaccountModel.swift
//  Sun Fun
//
//  Created by arab devolpers on 8/6/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import Foundation



import UIKit
import SwiftyJSON
class BankAccountModel: NSObject {
    
    var id:Int!
    var account_name:String?
    var account_IBAN:String?
    var account_bank_name:String?
    var account_number:String?
    
    init?(dict:[String:JSON]) {
        self.id = dict["id"]!.int
        self.account_name = dict["account_name"]!.string ?? ""
        self.account_IBAN = dict["account_IBAN"]!.string ?? ""
        self.account_bank_name = dict["account_bank_name"]!.string ?? ""
        self.account_number = dict["account_number"]!.string ?? ""
       
    }
}

