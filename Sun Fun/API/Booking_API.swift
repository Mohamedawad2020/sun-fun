//
//  Booking_API.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/30/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class Booking_API{
    let defaults = UserDefaults.standard

    func accept_Refuse_Booking(url:String,booking_id:Int,company_id:Int,notification_id:Int,event_id:Int,completion : @escaping(_ success: Bool, _ error:String) -> () ){
        
        let parameters : [String : Any] = [
            "booking_id":booking_id,
            "company_id":company_id,
            "notification_id":notification_id,
            "event_id":event_id,
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            
            switch response.response?.statusCode {
                
            case 422?:
                print("the status code is \(response.response?.statusCode ?? 0)")

                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON)
                    
                }
                completion(false,"server_error".localized())
            case 200?:
                print("the status code is \(response.response?.statusCode ?? 0)")

                switch response.result
                {
                    
                case .failure( let error):
                    print("in failure")
                    print(error)
                    
                    completion(false,"server_error".localized())
                    
                case .success(let data):
                    print("in success")
                    let json = JSON(data)
                    print(json)
                    
                    
                    completion(true,"")
                }
            default:
                print("the status code is \(response.response?.statusCode ?? 0)")
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON)
                }
                completion(false,"server_error".localized())
            }
            
            
        }
    }
}







