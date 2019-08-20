//
//  Edit+API.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/27/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class Edit_API{
    let defaults = UserDefaults.standard
    func update_user_image(id: Int,image: Data, completion : @escaping(_ success: Bool) -> () ){
        
        let params:[String:Any] = [
            "id":id
        ]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(image, withName: "image",fileName: "image.jpeg", mimeType: "image/jpeg")
               
                
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
        },
            to: updateUserImageUrl,
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
                                self.defaults.removeObject(forKey: "email")
                                self.defaults.removeObject(forKey: "name")
                                self.defaults.removeObject(forKey: "phone_code")
                                self.defaults.removeObject(forKey: "phone")
                                self.defaults.removeObject(forKey: "software_type")
                                ///
                                self.defaults.removeObject(forKey: "user_type")
                                self.defaults.removeObject(forKey: "be_company")
                                self.defaults.removeObject(forKey: "latitude")
                                self.defaults.removeObject(forKey: "longitude")
                                self.defaults.removeObject(forKey: "national_image")
                                //
                                self.defaults.removeObject(forKey: "responsible")
                                self.defaults.removeObject(forKey: "facebook_link")
                                self.defaults.removeObject(forKey: "twitter_link")
                                self.defaults.removeObject(forKey: "youtube_link")
                                
                                self.defaults.removeObject(forKey: "gmail_link")
                                self.defaults.removeObject(forKey: "lang")
                                self.defaults.removeObject(forKey: "ratings")
                                self.defaults.removeObject(forKey: "image")
                                self.defaults.removeObject(forKey: "address")
                                
                                self.defaults.removeObject(forKey: "id")
                                
                                ////////////////////////////////////////////////////////////////////////////////////
                                self.defaults.set(json["user"]["email"].stringValue, forKey: "email")
                                self.defaults.set(json["user"]["name"].stringValue, forKey: "name")
                                self.defaults.set(json["user"]["phone_code"].stringValue, forKey: "phone_code")
                                self.defaults.set(json["user"]["phone"].stringValue, forKey: "phone")
                                self.defaults.set(json["user"]["software_type"].stringValue, forKey: "software_type")
                                ///
                                self.defaults.set(json["user"]["user_type"].stringValue, forKey: "user_type")
                                self.defaults.set(json["user"]["be_company"].stringValue, forKey: "be_company")
                                self.defaults.set(json["user"]["latitude"].stringValue, forKey: "latitude")
                                self.defaults.set(json["user"]["longitude"].stringValue, forKey: "longitude")
                                self.defaults.set(json["user"]["national_image"].stringValue, forKey: "national_image")
                                //
                                self.defaults.set(json["user"]["responsible"].stringValue, forKey: "responsible")
                                self.defaults.set(json["user"]["facebook_link"].stringValue, forKey: "facebook_link")
                                self.defaults.set(json["user"]["twitter_link"].stringValue, forKey: "twitter_link")
                                self.defaults.set(json["user"]["youtube_link"].stringValue, forKey: "youtube_link")
                                
                                self.defaults.set(json["user"]["gmail_link"].stringValue, forKey: "gmail_link")
                                self.defaults.set(json["user"]["lang"].stringValue, forKey: "lang")
                                self.defaults.set(json["user"]["ratings"].stringValue, forKey: "ratings")
                                self.defaults.set(json["user"]["image"].stringValue, forKey: "image")
                                self.defaults.set(json["user"]["address"].stringValue, forKey: "address")

                                self.defaults.set(json["user"]["id"].intValue, forKey: "id")
//                                if json["information"].exists() && json["information"].dictionaryValue != nil{
//
//                                self.defaults.set(json["information"]["accepted"], forKey: "accepted")
//                                self.defaults.set(json["information"]["accepted"], forKey: "refused")
//                                self.defaults.set(json["information"]["accepted"], forKey: "money")
//                                self.defaults.set(json["information"]["accepted"], forKey: "site_money")
//                                self.defaults.set(json["information"]["accepted"], forKey: "credit_limit")
//
//
//                                }
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
    
    
    func update_user_profile(id:Int,name:String,email:String,phone_code:Int,phone:Int,completion : @escaping(_ success: Bool, _ error:String) -> () ){
        
        let parameters : [String : Any] = [
           "id":id,
           "name":name,
           "email":email,
           "phone_code":phone_code,
           "phone":phone
           
        ]
        Alamofire.request(updateUserProfileURL, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            
            switch response.response?.statusCode {
                
            case 422?:
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false,"")

            case 200?:
                switch response.result
                {
                    
                case .failure( let error):
                    
                    print(error)
                    
                    completion(false,"server_error".localized())
                    
                case .success(let data):
                    
                    let json = JSON(data)
                    print(json)
                    self.defaults.removeObject(forKey: "email")
                    self.defaults.removeObject(forKey: "name")
                    self.defaults.removeObject(forKey: "phone_code")
                    self.defaults.removeObject(forKey: "phone")
                    self.defaults.removeObject(forKey: "software_type")
                    ///
                    self.defaults.removeObject(forKey: "user_type")
                    self.defaults.removeObject(forKey: "be_company")
                    self.defaults.removeObject(forKey: "latitude")
                    self.defaults.removeObject(forKey: "longitude")
                    self.defaults.removeObject(forKey: "national_image")
                    //
                    self.defaults.removeObject(forKey: "responsible")
                    self.defaults.removeObject(forKey: "facebook_link")
                    self.defaults.removeObject(forKey: "twitter_link")
                    self.defaults.removeObject(forKey: "youtube_link")
                    
                    self.defaults.removeObject(forKey: "gmail_link")
                    self.defaults.removeObject(forKey: "lang")
                    self.defaults.removeObject(forKey: "ratings")
                    self.defaults.removeObject(forKey: "image")
                    self.defaults.removeObject(forKey: "address")
                    
                    self.defaults.removeObject(forKey: "id")
                    
                    ////////////////////////////////////////////////////////////////////////////////////
                    
                    self.defaults.set(json["user"]["email"].stringValue, forKey: "email")
                    self.defaults.set(json["user"]["name"].stringValue, forKey: "name")
                    self.defaults.set(json["user"]["phone_code"].stringValue, forKey: "phone_code")
                    self.defaults.set(json["user"]["phone"].stringValue, forKey: "phone")
                    self.defaults.set(json["user"]["software_type"].stringValue, forKey: "software_type")
                    ///
                    self.defaults.set(json["user"]["user_type"].stringValue, forKey: "user_type")
                    self.defaults.set(json["user"]["be_company"].stringValue, forKey: "be_company")
                    self.defaults.set(json["user"]["latitude"].stringValue, forKey: "latitude")
                    self.defaults.set(json["user"]["longitude"].stringValue, forKey: "longitude")
                    self.defaults.set(json["user"]["national_image"].stringValue, forKey: "national_image")
                    //
                    self.defaults.set(json["user"]["responsible"].stringValue, forKey: "responsible")
                    self.defaults.set(json["user"]["facebook_link"].stringValue, forKey: "facebook_link")
                    self.defaults.set(json["user"]["twitter_link"].stringValue, forKey: "twitter_link")
                    self.defaults.set(json["user"]["youtube_link"].stringValue, forKey: "youtube_link")
                    
                    self.defaults.set(json["user"]["gmail_link"].stringValue, forKey: "gmail_link")
                    self.defaults.set(json["user"]["lang"].stringValue, forKey: "lang")
                    self.defaults.set(json["user"]["ratings"].stringValue, forKey: "ratings")
                    self.defaults.set(json["user"]["image"].stringValue, forKey: "image")
                    self.defaults.set(json["user"]["address"].stringValue, forKey: "address")
                    
                    self.defaults.set(json["user"]["id"].intValue, forKey: "id")
//                    if json["information"].exists() && json["information"].dictionaryValue != nil{
//                        
//                        self.defaults.set(json["information"]["accepted"], forKey: "accepted")
//                        self.defaults.set(json["information"]["accepted"], forKey: "refused")
//                        self.defaults.set(json["information"]["accepted"], forKey: "money")
//                        self.defaults.set(json["information"]["accepted"], forKey: "site_money")
//                        self.defaults.set(json["information"]["accepted"], forKey: "credit_limit")
//                        
//                        
//                    }
                    self.defaults.set(true, forKey: "is_login")
                    
                    completion(true,"")
                }
            default:
                print("the status code is \(response.response?.statusCode ?? 0)")
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false,"")

            }
            
            
        }
    }
    
    func upgradeToCompany(id: Int,national_image: Data,address:String,responsible:String,latitude:Double,longitude:Double, completion : @escaping(_ success: Bool) -> () ){
        
        let params:[String:Any] = [
            "id":id,
            "address":address,
            "responsible":responsible,
            "latitude":latitude,
            "longitude":longitude
        ]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(national_image, withName: "national_image",fileName: "national_image.jpeg", mimeType: "national_image/jpeg")
                
                
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
        },
            to: upgradeToComanyURL,
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
                                self.defaults.set(json["email"].stringValue, forKey: "email")
                                self.defaults.set(json["name"].stringValue, forKey: "name")
                                self.defaults.set(json["phone_code"].stringValue, forKey: "phone_code")
                                self.defaults.set(json["phone"].stringValue, forKey: "phone")
                                self.defaults.set(json["software_type"].stringValue, forKey: "software_type")
                                ///
                                self.defaults.set(json["user_type"].stringValue, forKey: "user_type")
                                self.defaults.set(json["be_company"].stringValue, forKey: "be_company")
                                self.defaults.set(json["latitude"].stringValue, forKey: "latitude")
                                self.defaults.set(json["longitude"].stringValue, forKey: "longitude")
                                self.defaults.set(json["national_image"].stringValue, forKey: "national_image")
                                //
                                self.defaults.set(json["responsible"].stringValue, forKey: "responsible")
                                self.defaults.set(json["facebook_link"].stringValue, forKey: "facebook_link")
                                self.defaults.set(json["twitter_link"].stringValue, forKey: "twitter_link")
                                self.defaults.set(json["youtube_link"].stringValue, forKey: "youtube_link")
                                
                                self.defaults.set(json["gmail_link"].stringValue, forKey: "gmail_link")
                                self.defaults.set(json["lang"].stringValue, forKey: "lang")
                                self.defaults.set(json["ratings"].stringValue, forKey: "ratings")
                                self.defaults.set(json["image"].stringValue, forKey: "image")
                                
                                self.defaults.set(json["id"].intValue, forKey: "id")
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
    
    func update_user_password(id:Int,password:String,completion : @escaping(_ success: Bool, _ error:String) -> () ){
        
        let parameters : [String : Any] = [
            "id":id,
            "password":password
        ]
        Alamofire.request(userPasswordURL, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            
            switch response.response?.statusCode {
                
            case 422?:
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false,"")
                
            case 200?:
                switch response.result
                {
                    
                case .failure( let error):
                    
                    print(error)
                    
                    completion(false,"server_error".localized())
                    
                case .success(let data):
                    
                    let json = JSON(data)
                    print(json)
                    self.defaults.removeObject(forKey: "email")
                    self.defaults.removeObject(forKey: "name")
                    self.defaults.removeObject(forKey: "phone_code")
                    self.defaults.removeObject(forKey: "phone")
                    self.defaults.removeObject(forKey: "software_type")
                    ///
                    self.defaults.removeObject(forKey: "user_type")
                    self.defaults.removeObject(forKey: "be_company")
                    self.defaults.removeObject(forKey: "latitude")
                    self.defaults.removeObject(forKey: "longitude")
                    self.defaults.removeObject(forKey: "national_image")
                    //
                    self.defaults.removeObject(forKey: "responsible")
                    self.defaults.removeObject(forKey: "facebook_link")
                    self.defaults.removeObject(forKey: "twitter_link")
                    self.defaults.removeObject(forKey: "youtube_link")
                    
                    self.defaults.removeObject(forKey: "gmail_link")
                    self.defaults.removeObject(forKey: "lang")
                    self.defaults.removeObject(forKey: "ratings")
                    self.defaults.removeObject(forKey: "image")
                    self.defaults.removeObject(forKey: "address")
                    
                    self.defaults.removeObject(forKey: "id")
                    
                    ////////////////////////////////////////////////////////////////////////////////////
                    
                    self.defaults.set(json["user"]["email"].stringValue, forKey: "email")
                    self.defaults.set(json["user"]["name"].stringValue, forKey: "name")
                    self.defaults.set(json["user"]["phone_code"].stringValue, forKey: "phone_code")
                    self.defaults.set(json["user"]["phone"].stringValue, forKey: "phone")
                    self.defaults.set(json["user"]["software_type"].stringValue, forKey: "software_type")
                    ///
                    self.defaults.set(json["user"]["user_type"].stringValue, forKey: "user_type")
                    self.defaults.set(json["user"]["be_company"].stringValue, forKey: "be_company")
                    self.defaults.set(json["user"]["latitude"].stringValue, forKey: "latitude")
                    self.defaults.set(json["user"]["longitude"].stringValue, forKey: "longitude")
                    self.defaults.set(json["user"]["national_image"].stringValue, forKey: "national_image")
                    //
                    self.defaults.set(json["user"]["responsible"].stringValue, forKey: "responsible")
                    self.defaults.set(json["user"]["facebook_link"].stringValue, forKey: "facebook_link")
                    self.defaults.set(json["user"]["twitter_link"].stringValue, forKey: "twitter_link")
                    self.defaults.set(json["user"]["youtube_link"].stringValue, forKey: "youtube_link")
                    
                    self.defaults.set(json["user"]["gmail_link"].stringValue, forKey: "gmail_link")
                    self.defaults.set(json["user"]["lang"].stringValue, forKey: "lang")
                    self.defaults.set(json["user"]["ratings"].stringValue, forKey: "ratings")
                    self.defaults.set(json["user"]["image"].stringValue, forKey: "image")
                    self.defaults.set(json["user"]["address"].stringValue, forKey: "address")
                    
                    self.defaults.set(json["user"]["id"].intValue, forKey: "id")
                    //                    if json["information"].exists() && json["information"].dictionaryValue != nil{
                    //
                    //                        self.defaults.set(json["information"]["accepted"], forKey: "accepted")
                    //                        self.defaults.set(json["information"]["accepted"], forKey: "refused")
                    //                        self.defaults.set(json["information"]["accepted"], forKey: "money")
                    //                        self.defaults.set(json["information"]["accepted"], forKey: "site_money")
                    //                        self.defaults.set(json["information"]["accepted"], forKey: "credit_limit")
                    //
                    //
                    //                    }
                    self.defaults.set(true, forKey: "is_login")
                    
                    completion(true,"")
                }
            default:
                print("the status code is \(response.response?.statusCode ?? 0)")
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false,"")
                
            }
            
            
        }
    }
}
