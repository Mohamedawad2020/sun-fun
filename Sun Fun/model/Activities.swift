//
//  Activities.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/24/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//


import UIKit
import SwiftyJSON
class Activities: NSObject {
 
        var id:Int!
        var event_id:Int?
        var ar_title:String?
        var en_title:String?
        var ar_place:String?
        var en_place:String?
        var image:String?
        var start_at:Int?
        var end_at:Int?
        var address:String?
        var available:Int?
        var price:Int?
        var max_number:Int?
        var booking_number:Int?
        var unit:String?
    
        init?(dict:[String:JSON]) {
            self.id = dict["id"]!.int
            self.ar_title = dict["ar_title"]!.string ?? ""
            self.en_title = dict["en_title"]!.string ?? ""
            self.ar_place = dict["ar_place"]!.string ?? ""
            self.en_place = dict["en_place"]!.string ?? ""
            self.image = dict["image"]!.string ?? ""
            self.start_at = dict["start_at"]!.int ?? 0
            self.end_at = dict["end_at"]!.int ?? 0
            self.address = dict["address"]!.string ?? ""
            self.available = dict["available"]!.int ?? 0
            self.price = dict["price"]!.int ?? 0
            self.max_number = dict["max_number"]!.int ?? 0
            self.booking_number = dict["booking_number"]!.int ?? 0
            self.unit = dict["unit"]!.string ?? ""

        }
    }

