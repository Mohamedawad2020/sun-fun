//
//  OrderHelper.swift
//  Emdad
//
//  Created by arab devolpers on 7/3/19.
//  Copyright © 2019 creative. All rights reserved.
//

import Foundation
struct OrderHelper {
    
    
    
    
    static func getOrderName(ordertype:String)-> String{
        var Ordername = ""
        switch ordertype {
        case "1":
            Ordername = "water_connect".localized()
        case "2":
            Ordername = "Rental_equipment".localized()
        case "3":
            Ordername = "shipping".localized()
        case "4":
            Ordername = "containers".localized()
        case "5":
            Ordername = "custmos".localized()
        case "6":
            Ordername = "engineeringconsultances".localized()
        default:
            Ordername = "orderNameError".localized()
        }
        return Ordername
    }
}
