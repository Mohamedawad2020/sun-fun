//
//  AddEvent_API.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/28/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class AddEvent_API{
    let defaults = UserDefaults.standard
    func addEvent(company_id: Int, ar_title:String,en_title:String,ar_description:String,en_description:String,start_at: Int,end_at:Int,from_time:Int,to_time:Int,address:String,image1:Data,image2:Data,latitude:Double,longitude:Double
        ,price:String,max_number:String,ar_information:String,en_information:String,cat_id:Int,sub_id:Int,completion : @escaping(_ success: Bool,_ event_id: Int?) -> () ){
        
        let params:[String:Any] = [
            "company_id":company_id,
            "ar_title":ar_title,
            "en_title":en_title,
            "ar_description":ar_description,
            "en_description":en_description,

            "start_at":start_at,
            "end_at":end_at,
            "from_time":from_time,
            "to_time":to_time,
            "address":address,
            "image1":image1,
            "image2":image2,
            "latitude":latitude,
            "longitude":longitude,
            "price":price,
            "max_number":max_number,
            "ar_information":ar_information,
            "en_information":en_information,

            "cat_id":cat_id,
            "sub_id":sub_id
        ]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(image1, withName: "image1",fileName: "image1.jpeg", mimeType: "image1/jpeg")
                multipartFormData.append(image2, withName: "image2",fileName: "image2.jpeg", mimeType: "image2/jpeg")

                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
        },
            to: addEventurl,
            method: .post,
            
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.validate(statusCode: 200..<300)
                        .responseJSON { data in
                            switch data.response?.statusCode{
                            case 200?:
                                print("the status code is \(data.response?.statusCode ?? 0)")
                                
                                let json = JSON(data.data)
                                ///
                                
                                self.defaults.set(json["event_id"].stringValue, forKey: "activity_event_id")
                                self.defaults.set(json["ar_title"].stringValue, forKey: "activity_ar_title")
                                self.defaults.set(json["ar_place"].stringValue, forKey: "activity_ar_place")
                                self.defaults.set(json["start_at"].stringValue, forKey: "activity_start_at")
                                self.defaults.set(json["end_at"].stringValue, forKey: "activity_end_at")
                                ///
                                self.defaults.set(json["address"].stringValue, forKey: "activity_address")
                                self.defaults.set(json["image"].stringValue, forKey: "activity_image")
                                self.defaults.set(json["unit"].stringValue, forKey: "activity_unit")
                                self.defaults.set(json["max_number"].stringValue, forKey: "activity_max_number")
                                self.defaults.set(json["price"].stringValue, forKey: "activity_price")
                                //
                                
                                self.defaults.set(json["id"].intValue, forKey: "activity_id")
                                print("event id is \(json["id"].intValue)")
                                completion(true,json["id"].intValue)
                            case 422?:
                                print("the status code is \(data.response?.statusCode ?? 0)")
                                let responseJSON = try? JSON(data: data.data!)
                                print(responseJSON ?? 0)
                                print("you are failed")
                                completion(false,nil)
                                
                            default :
                                print("the status code is \(data.response?.statusCode ?? 0)")
                                let responseJSON = try? JSON(data: data.data!)
                                print(responseJSON ?? 0)
                                print("you are failed")
                                completion(false,nil)
                            }
                            
                    }
                case .failure(let encodingError):
                    print("the error is :\(encodingError)")
                    
                    completion(false,nil)
                    
                }
        }
        )
        
    }

    func addActivity(event_id: Int,start_at:Int,end_at:Int,image: Data,unit:String,price:String,max_number:String,ar_title:String,en_title:String,ar_place:String,en_place:String, completion : @escaping(_ success: Bool) -> () ){
        
        let params:[String:Any] = [
            "event_id":event_id,
            "start_at":start_at,
            "end_at":end_at,
            "unit":unit,
            "price":price,
            "max_number":max_number,
            "ar_title":ar_title,
            "en_title":en_title,

            "ar_place":ar_place,

            "en_place":en_place
        ]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(image, withName: "image",fileName: "image.jpeg", mimeType: "image/jpeg")
                
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
        },
            to: addActivityURL,
            method: .post,
            
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.validate(statusCode: 200..<300)
                        .responseJSON { data in
                            switch data.response?.statusCode{
                            case 200?:
                                print("the status code is \(data.response?.statusCode ?? 0)")
                                
                                let json = JSON(data.data)
                                ///
                                
                                self.defaults.set(json["event_id"].stringValue, forKey: "activity_event_id")
                                self.defaults.set(json["ar_title"].stringValue, forKey: "activity_ar_title")
                                self.defaults.set(json["ar_place"].stringValue, forKey: "activity_ar_place")
                                self.defaults.set(json["start_at"].stringValue, forKey: "activity_start_at")
                                self.defaults.set(json["end_at"].stringValue, forKey: "activity_end_at")
                                ///
                                self.defaults.set(json["address"].stringValue, forKey: "activity_address")
                                self.defaults.set(json["image"].stringValue, forKey: "activity_image")
                                self.defaults.set(json["unit"].stringValue, forKey: "activity_unit")
                                self.defaults.set(json["max_number"].stringValue, forKey: "activity_max_number")
                                self.defaults.set(json["price"].stringValue, forKey: "activity_price")
                                //
                               
                                self.defaults.set(json["id"].intValue, forKey: "activity_id")
                                completion(true)
                            case 422?:
                                print("the status code is \(data.response?.statusCode ?? 0)")
                                let responseJSON = try? JSON(data: data.data!)
                                print(responseJSON ?? 0)
                                print("you are failed")
                                completion(false)
                                
                            default :
                                print("the status code is \(data.response?.statusCode ?? 0)")
                                let responseJSON = try? JSON(data: data.data!)
                                print(responseJSON ?? 0)
                                print("you are failed")
                                completion(false)
                            }
                            
                    }
                case .failure(let encodingError):
                    print("the error is :\(encodingError)")
                    
                    completion(false)
                    
                }
        }
        )
        
    }
    func EditEvent(id:Int,company_id: Int, ar_title:String,ar_description:String,start_at: Int,end_at:Int,from_time:Int,to_time:Int,address:String,image1:Data,image2:Data,latitude:Double,longitude:Double
        ,price:String,max_number:String,ar_information:String,cat_id:Int,sub_id:Int,completion : @escaping(_ success: Bool) -> () ){
        
        let params:[String:Any] = [
            "id":id,
            "company_id":company_id,
            "ar_title":ar_title,
            "ar_description":ar_description,
            "start_at":start_at,
            "end_at":end_at,
            "from_time":from_time,
            "to_time":to_time,
            "address":address,
            "image1":image1,
            "image2":image2,
            "latitude":latitude,
            "longitude":longitude,
            "price":price,
            "max_number":max_number,
            "ar_information":ar_information,
            "cat_id":cat_id,
            "sub_id":sub_id
        ]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(image1, withName: "image1",fileName: "image1.jpeg", mimeType: "image1/jpeg")
                multipartFormData.append(image2, withName: "image2",fileName: "image2.jpeg", mimeType: "image2/jpeg")
                
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
        },
            to: addEventurl,
            method: .post,
            
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.validate(statusCode: 200..<300)
                        .responseJSON { data in
                            switch data.response?.statusCode{
                            case 200?:
                                print("the status code is \(data.response?.statusCode ?? 0)")
                                
                                let json = JSON(data.data)
                                ///
                                
                                self.defaults.set(json["event_id"].stringValue, forKey: "activity_event_id")
                                self.defaults.set(json["ar_title"].stringValue, forKey: "activity_ar_title")
                                self.defaults.set(json["ar_place"].stringValue, forKey: "activity_ar_place")
                                self.defaults.set(json["start_at"].stringValue, forKey: "activity_start_at")
                                self.defaults.set(json["end_at"].stringValue, forKey: "activity_end_at")
                                ///
                                self.defaults.set(json["address"].stringValue, forKey: "activity_address")
                                self.defaults.set(json["image"].stringValue, forKey: "activity_image")
                                self.defaults.set(json["unit"].stringValue, forKey: "activity_unit")
                                self.defaults.set(json["max_number"].stringValue, forKey: "activity_max_number")
                                self.defaults.set(json["price"].stringValue, forKey: "activity_price")
                                //
                                
                                self.defaults.set(json["id"].intValue, forKey: "activity_id")
                                print("event id is \(json["id"].intValue)")
                                completion(true)
                            case 422?:
                                print("the status code is \(data.response?.statusCode ?? 0)")
                                let responseJSON = try? JSON(data: data.data!)
                                print(responseJSON ?? 0)
                                print("you are failed")
                                completion(false)
                                
                            default :
                                print("the status code is \(data.response?.statusCode ?? 0)")
                                let responseJSON = try? JSON(data: data.data!)
                                print(responseJSON ?? 0)
                                print("you are failed")
                                completion(false)
                            }
                            
                    }
                case .failure(let encodingError):
                    print("the error is :\(encodingError)")
                    
                    completion(false)
                    
                }
        }
        )
        
    }
    
}
