//
//  EventCellDetails.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/18/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
class EventSDetails: NSObject {
 
    var id:Int!
    var company_id:Int?
    var ar_title:String?
    var en_title:String?
    var ar_description:String?
    var en_description:String?
    var start_at:Int?
    var end_at:Int?
    var from_time:Int?
    var to_time:Int?
    var address:String?
    var image1:String?
    var image2:String?
    var latitude:Double?
    var longitude:Double?
    var max_number:Int?
    var price:Int?
    var status:Int?
    var rating:Int?
    var ar_information:String?
    var en_information:String?
    var cat_id:Int?
    var sub_id:Int?
    var responsible:String?
    var booking_number:Int?
    var is_booking:Int?
    var activities:[JSON]!
    init?(dict:[String:JSON]) {
        self.id = dict["id"]!.int
//        self.is_booking = dict["is_booking"]!.int
        self.company_id = dict["company_id"]!.int ?? 0
        self.ar_title = dict["ar_title"]!.string ?? ""
        self.en_title = dict["en_title"]!.string ?? ""
        self.ar_description = dict["ar_description"]!.string ?? ""
        self.en_description = dict["en_description"]!.string ?? ""
        self.start_at = dict["start_at"]!.int ?? 0
        self.end_at = dict["end_at"]!.int ?? 0
        self.from_time = dict["from_time"]!.int ?? 0

        self.to_time = dict["to_time"]!.int ?? 0
        self.address = dict["address"]!.string ?? ""
        self.image1 = dict["image1"]!.string ?? ""
        self.image2 = dict["image2"]!.string ?? ""
        self.latitude = dict["latitude"]!.double ?? 0
        self.longitude = dict["longitude"]!.double ?? 0
        self.max_number = dict["max_number"]!.int ?? 0
        self.price = dict["price"]!.int ?? 0
        self.status = dict["status"]!.int ?? 0
        self.rating = dict["rating"]!.int ?? 0
        self.ar_information = dict["ar_information"]!.string ?? ""
        self.en_information = dict["en_information"]!.string ?? ""
        self.booking_number = dict["booking_number"]!.int ?? 0
        self.cat_id = dict["cat_id"]!.int ?? 0
        self.responsible = dict["responsible"]!.string ?? ""
        self.sub_id = dict["sub_id"]!.int ?? 0
        self.activities = (dict["activities"]?.array)!
        self.is_booking = dict["is_booking"]!.int ?? 0
    }
    
}
