//
//  Cities.swift
//  Emdad
//
//  Created by arab devolpers on 6/16/19.
//  Copyright © 2019 creative. All rights reserved.
//

import UIKit
import SwiftyJSON
class Cities: NSObject {
   // self.name = dict["name"]!.string ?? ""
   
    var id_city:String!
    var ar_city_title:String!
    var en_city_title:String!
    
    init?(dict:[String:JSON]) {
        
        self.id_city = dict["id_city"]!.string ?? ""
        self.ar_city_title = dict["ar_city_title"]!.string ?? ""
        self.en_city_title = dict["en_city_title"]!.string ?? ""
        
    }
    
    
    
}
