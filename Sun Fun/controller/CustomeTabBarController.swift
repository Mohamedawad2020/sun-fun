//
//  CustomeTabBarController.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/21/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import Floaty
class CustomeTabBarController: UITabBarController{

    let user_type = UserDefaults.standard.integer(forKey: "user_type")
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
       
      
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 2 && user_type == 2{
            
            
        }
        print("the tag is \(item.tag)")
    }
    
  
    
  
}
