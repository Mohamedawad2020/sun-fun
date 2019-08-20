//
//  NotificationModel.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/29/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import SwiftyJSON
class NotificationModel: NSObject {
    // self.name = dict["name"]!.string ?? ""
    
  
    var id:Int!
    var from_id:Int!
    var to_id:Int!
    var notification_sender:Int!
    var notification_receiver:Int!
    var notification_type:Int!
    var notification_date:Int!
    var notification_read:Int!
    var action_type:Int!
    var event_id:Int!
    var booking_id:Int!
    var status:Int!

    init?(dict:[String:JSON]) {
        
        self.id = dict["id"]!.int
        self.from_id = dict["from_id"]!.int ?? 0
        self.to_id = dict["to_id"]!.int ?? 0
        self.notification_sender = dict["notification_sender"]!.int ?? 0
        self.notification_receiver = dict["notification_receiver"]!.int ?? 0
        self.notification_type = dict["notification_type"]!.int ?? 0
        self.notification_date = dict["notification_date"]!.int ?? 0
        self.notification_read = dict["notification_read"]!.int ?? 0
        self.action_type = dict["action_type"]!.int ?? 0
        self.event_id = dict["event_id"]!.int ?? 0
        self.booking_id = dict["booking_id"]!.int ?? 0
        self.status = dict["status"]!.int ?? 0

    }
    
    
    
}

