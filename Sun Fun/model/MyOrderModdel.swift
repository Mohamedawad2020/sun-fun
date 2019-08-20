//
//  MyOrderModdel.swift
//  Sun Fun
//
//  Created by arab devolpers on 8/3/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//
import UIKit
import SwiftyJSON
class MyOrderModel: NSObject {

    class Booking{
        var id:Int!
      
        var company_id:Int?
        var user_id:Int?
        var event_id:Int?
        var booking_code:String?
        var booking_image:String?
        var total_booking_price:Int?
        var event_price:Int?
        var status:Int?
        var subscribers_num:Int?
        var paid_type:Int?
        var date:Int?
        var company_name:String?
        var responsible:String?
        var is_booking:Int?
        var event_ar_title:String?
        var event_en_title:String?
        var event_image:String?
        var booking_details:[JSON]!
        init?(dict:[String:JSON]) {
            
            self.id = dict["id"]!.int
            self.company_id = dict["company_id"]!.int ?? 0
            self.user_id = dict["user_id"]!.int ?? 0
            self.event_id = dict["event_id"]!.int ?? 0
            self.booking_code = dict["booking_code"]!.string ?? ""
            
            self.total_booking_price = dict["total_booking_price"]!.int ?? 0
            self.event_price = dict["event_price"]!.int ?? 0
            self.status = dict["status"]!.int ?? 0
            self.subscribers_num = dict["subscribers_num"]!.int ?? 0
            self.paid_type = dict["paid_type"]!.int ?? 0
            self.date = dict["date"]!.int ?? 0
            self.company_name = dict["company_name"]!.string ?? ""
            self.responsible = dict["responsible"]!.string ?? ""
            self.is_booking = dict["is_booking"]!.int ?? 0
            self.event_ar_title = dict["event_ar_title"]!.string ?? ""
            self.event_en_title = dict["event_en_title"]!.string ?? ""
            self.event_image = dict["event_image"]!.string ?? ""
            self.booking_details = (dict["booking_details"]?.array)!
            self.booking_image = dict["booking_image"]!.string ?? ""
            
        }
    }
    
    
    class booking_details{
       
        var id:Int!
        var booking_id:Int?
        var event_id:Int?
        var activity_id:Int?
        var subscribers_num:Int?
        var total_activaty_price:Int?
        var activitie_ar_title:String?
        var activitie_en_title:String?
        var activitie_image:String?

        init?(dict:[String:JSON]) {
            
            self.id = dict["id"]!.int
            self.booking_id = dict["booking_id"]!.int ?? 0
            self.event_id = dict["event_id"]!.int ?? 0
            self.activity_id = dict["activity_id"]!.int ?? 0
            self.subscribers_num = dict["subscribers_num"]!.int ?? 0
            self.total_activaty_price = dict["total_activaty_price"]!.int ?? 0
            self.activitie_ar_title = dict["activitie_ar_title"]!.string ?? ""
            self.activitie_en_title = dict["activitie_en_title"]!.string ?? ""
            self.activitie_image = dict["activitie_image"]!.string ?? ""

        }
        
        
        
    }
    
    
}
