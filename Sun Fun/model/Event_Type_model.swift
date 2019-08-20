//
//  Event_Type_model.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/17/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//


import UIKit
import SwiftyJSON
class EventTypes: NSObject {
   
    class types{
        var id:Int!
        var ar_title:String?
        var en_title:String?
        var sub_categories:[JSON]!
        init?(dict:[String:JSON]) {
            
            self.id = dict["id"]!.int
            self.ar_title = dict["ar_title"]!.string ?? ""
            self.en_title = dict["en_title"]!.string ?? ""
            self.sub_categories = (dict["sub_categories"]?.array)!
            
        }
    }
    
    
    class Event_sub_category{
        
        var id:Int!
        var ar_title:String?
        var en_title:String?
        var cat_id:Int?
        init?(dict:[String:JSON]) {
            
            self.id = dict["id"]!.int
            self.ar_title = dict["ar_title"]!.string ?? ""
            self.en_title = dict["en_title"]!.string ?? ""
            self.cat_id = dict["cat_id"]!.int ?? 0
        }
        
        
        
    }
    
    
}
