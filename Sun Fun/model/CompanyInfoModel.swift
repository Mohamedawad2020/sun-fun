//
//  CompanyInfoModel.swift
//  Sun Fun
//
//  Created by arab devolpers on 8/7/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import Foundation

import UIKit
import SwiftyJSON
class CompanyInfoModel: NSObject {
    
    var accepted:Int!
    var refused:Int!
    var money:Int!
    var site_money:Int!
    var credit_limit:Int!

    init?(dict:[String:JSON]) {
        self.accepted = dict["accepted"]!.int
        self.refused = dict["refused"]!.int
        self.money = dict["money"]!.int
        self.site_money = dict["site_money"]!.int
        self.credit_limit = dict["credit_limit"]!.int

    }
}
