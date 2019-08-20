//
//  PaymentMethodModel.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/25/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import Foundation

import UIKit
import SwiftyJSON
class PaymentMethodModel: NSObject {
    
  
        var id:Int!
        var ar_title:String?
        var en_title:String?
    
        init?(dict:[String:JSON]) {
            
            self.id = dict["id"]!.int
            self.ar_title = dict["ar_title"]!.string ?? ""
            self.en_title = dict["en_title"]!.string ?? ""
           
            
        }
    }

