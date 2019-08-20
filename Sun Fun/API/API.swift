//
//  API.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/16/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class API{
    
    let isArabic = UserDefaults.standard.bool(forKey: "is_arabic")

    let defaults = UserDefaults.standard
    func register(name:String,email:String,password:String,phone_code:String,phone:String,software_type:Int,completion : @escaping(_ success: Bool, _ error:Int) -> () ){
        
        let parameters : [String : Any] = [
            "name":name,
            "email":email,
            "password":password,
            "phone_code":phone_code,
            "phone":phone,
            "software_type":software_type
        ]
        Alamofire.request(registerURl, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            
            switch response.response?.statusCode {
                
            case 422?:
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false,0)
            case 200?:
                switch response.result
                {
                    
                case .failure( let error):
                    
                    print(error)
                    
                    completion(false,0)
                    
                case .success(let data):
                    
                    let json = JSON(data)
                    print(json)
                  
                    self.defaults.set(json["api_token"].stringValue, forKey: "api_token")
                    self.defaults.set(json["user"]["email"].stringValue, forKey: "email")
                    self.defaults.set(json["user"]["name"].stringValue, forKey: "name")
                    self.defaults.set(json["user"]["phone_code"].stringValue, forKey: "phone_code")
                    self.defaults.set(json["user"]["phone"].stringValue, forKey: "phone")
                    self.defaults.set(json["user"]["software_type"].intValue, forKey: "software_type")
                    ///
                    self.defaults.set(json["user"]["user_type"].intValue, forKey: "user_type")
                    self.defaults.set(json["user"]["be_company"].intValue, forKey: "be_company")
                    self.defaults.set(json["user"]["latitude"].doubleValue, forKey: "latitude")
                    self.defaults.set(json["user"]["longitude"].doubleValue, forKey: "longitude")
                    self.defaults.set(json["user"]["national_image"].stringValue, forKey: "national_image")
                    //
                    self.defaults.set(json["user"]["responsible"].stringValue, forKey: "responsible")
                    self.defaults.set(json["user"]["facebook_link"].stringValue, forKey: "facebook_link")
                    self.defaults.set(json["user"]["twitter_link"].stringValue, forKey: "twitter_link")
                    self.defaults.set(json["user"]["youtube_link"].stringValue, forKey: "youtube_link")
                    
                    self.defaults.set(json["user"]["gmail_link"].stringValue, forKey: "gmail_link")
                    self.defaults.set(json["user"]["lang"].stringValue, forKey: "lang")
                    self.defaults.set(json["user"]["ratings"].intValue, forKey: "ratings")
                    self.defaults.set(json["user"]["image"].stringValue, forKey: "image")
                    
                    
                    self.defaults.set(json["user"]["id"].intValue, forKey: "id")
                    self.defaults.set(true, forKey: "is_login")
        
                    completion(true,json["user"]["user_type"].intValue)
                }
            default:
                print("the status code is \(response.response?.statusCode ?? 0)")
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false,0)
            }
            
            
        }
    }
    func logOut(completion : @escaping(_ success: Bool, _ error:String) -> () ){
        
       
        Alamofire.request(logoutUrl, method: .post, parameters: nil, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            
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
    
    func login(email:String,password:String,completion : @escaping(_ success: Bool, _ error:Int) -> () ){
        
        let parameters : [String : Any] = [
            "email":email,
            "password":password
        ]
        Alamofire.request(LoginURL, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            
            switch response.response?.statusCode {
            case 404?:
                completion(false,0)
                if let dat = response.data {
                    print(dat)
                    
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
            case 422?:
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
            case 200?:
                switch response.result
                {
                    
                case .failure( let error):
                    
                    print(error)
                    
                    completion(false,0)
                    
                case .success(let data):
                    
                    let json = JSON(data)
                    print(json)
                  
                    self.defaults.set(json["api_token"].stringValue, forKey: "api_token")
                    self.defaults.set(json["user"]["email"].stringValue, forKey: "email")
                    self.defaults.set(json["user"]["name"].stringValue, forKey: "name")
                    self.defaults.set(json["user"]["phone_code"].stringValue, forKey: "phone_code")
                    self.defaults.set(json["user"]["phone"].stringValue, forKey: "phone")
                    self.defaults.set(json["user"]["software_type"].intValue, forKey: "software_type")
///
                    self.defaults.set(json["user"]["user_type"].intValue, forKey: "user_type")
                    self.defaults.set(json["user"]["be_company"].intValue, forKey: "be_company")
                    self.defaults.set(json["user"]["latitude"].doubleValue, forKey: "latitude")
                    self.defaults.set(json["user"]["longitude"].doubleValue, forKey: "longitude")
                    self.defaults.set(json["user"]["national_image"].stringValue, forKey: "national_image")
                   //
                    self.defaults.set(json["user"]["responsible"].stringValue, forKey: "responsible")
                    self.defaults.set(json["user"]["facebook_link"].stringValue, forKey: "facebook_link")
                    self.defaults.set(json["user"]["twitter_link"].stringValue, forKey: "twitter_link")
                    self.defaults.set(json["user"]["youtube_link"].stringValue, forKey: "youtube_link")
                    
                    self.defaults.set(json["user"]["gmail_link"].stringValue, forKey: "gmail_link")
                    self.defaults.set(json["user"]["lang"].stringValue, forKey: "lang")
                    self.defaults.set(json["user"]["ratings"].intValue, forKey: "ratings")
                    self.defaults.set(json["user"]["image"].stringValue, forKey: "image")


                    self.defaults.set(json["user"]["id"].intValue, forKey: "id")
                    self.defaults.set(true, forKey: "is_login")
                   
//                    if json["information"].dictionaryValue != nil{
//                        
//                        self.defaults.set(json["information"]["accepted"], forKey: "accepted")
//                        self.defaults.set(json["information"]["accepted"], forKey: "refused")
//                        self.defaults.set(json["information"]["accepted"], forKey: "money")
//                        self.defaults.set(json["information"]["accepted"], forKey: "site_money")
//                        self.defaults.set(json["information"]["accepted"], forKey: "credit_limit")
//                        
//                        
//                    }
                    
                    completion(true,json["user"]["user_type"].intValue)
                }
            default:
                print("the status code is \(response.response?.statusCode ?? 0)")
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false,0)
            }
            
            
        }
    }
    func get_Events_Type(completion : @escaping(_ success: Bool, _ result:[EventTypes.types]?) -> () ){
        
        Alamofire.request(eventTypesURL, method: .get, parameters: nil, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.response?.statusCode{
                case 200?:
                    print("the status code is \(response.response?.statusCode ?? 0)")
                    switch response.result{
                    case .failure( let error):
                        //print("in fail")
                        //print("the status code is \(response.response?.statusCode ?? 0)")
                        if let dat = response.data {
                            //print("respone data \(dat)")
                            let responseJSON = try? JSON(data: dat)
                           // print(responseJSON ?? 0)
                        }
                        print(error)
                        completion(false,nil)
                    case .success(let value):
                        print("in success")
                        let json = JSON(value)
                        //print(json)
                        let event_Data_Type = json["data"]
                        
                        //print(event_Data_Type)
                        
                        guard let dataArr1 = event_Data_Type.array else{
                            completion(false , nil)
                            return
                        }
                        
                        var result1 = [EventTypes.types]()
                       

                        for data in dataArr1 {
                            
                            if let data = data.dictionary ,let info = EventTypes.types.init(dict: data) {
                                result1.append(info)
                            }
                        }
                        completion(true,result1)
                    }
                    
                case 422?:
                    print("the status code is \(response.response?.statusCode ?? 0)")
                    completion(false,nil)

                default:
                    print("the status code is \(response.response?.statusCode ?? 0)")
                    if let dat = response.data {
                        print("respone data \(dat)")
                        let responseJSON = try? JSON(data: dat)
                        print(responseJSON ?? 0)
                    }
                    completion(false,nil)

                }
        }
        
    }
  
    func getAllEvents(page:Int,user_id:Int,completion : @escaping(_ success: Bool, _ result:[EventSDetails]?) -> () ){
        let parameters:[String:Int] = [
            "id":user_id,
            "page":page
        ]
        
        
        
        Alamofire.request(allEventsURL, method: .get, parameters: parameters, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.response?.statusCode {
            case 422?:
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false,nil)

            case 200?:
                 print("get all events Status code  == \(response.response?.statusCode ?? 0)")
                switch response.result{
                case .failure( let error):
                    print(error)
                    completion(false,nil)
                case .success(let value):
                    let json = JSON(value)
                    let datobj = json["data"]
                    self.defaults.set(json["total"].intValue, forKey: "total")
                    
                    guard let dataArr = datobj.array else{
                        completion(false , [EventSDetails]())
                        return
                    }
                    var results = [EventSDetails]()
                    for data in dataArr {
                        if let data = data.dictionary ,let info = EventSDetails.init(dict: data) {
                            results.append(info)
                        }
                    }
                    completion(true,results)
                }
            default:
                print("get all events Status code  == \(response.response?.statusCode ?? 0)")
                if let dat = response.data {
                    //print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON)
                }
                completion(false,nil)

                
            }
        }
        
    }
    func searchByCategory(user_id:Int,id:Int,cat_id:Int,completion : @escaping(_ success: Bool, _ result:[EventSDetails]?) -> () ){
        
        
        let parameters:[String : Any] = [
            "id":id,
            "cat_id":cat_id,
            "user_id":user_id
        ]
        
        Alamofire.request(searchByCategoryURl, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.response?.statusCode {
            case 422?:
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false,nil)

            case 200?:
                switch response.result{
                case .failure( let error):
                    print(error)
                    completion(false,nil)
                case .success(let value):
                    let json = JSON(value)
                    let datobj = json
                    print(json)
                    
                    
                    guard let dataArr = datobj["data"].array else{
                        completion(false , [EventSDetails]())
                        return
                    }
                    var results = [EventSDetails]()
                    for data in dataArr {
                        if let data = data.dictionary ,let info = EventSDetails.init(dict: data) {
                            results.append(info)
                        }
                    }
                    completion(true,results)
                }
            default:
                print("search by category status code  == \(response.response?.statusCode ?? 0)")
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON)
                }
                completion(false,nil)

            }
        }
        
    }
    func paymentMethod(completion : @escaping(_ success: Bool, _ result:[PaymentMethodModel]?) -> () ){
        
        
        
        
        Alamofire.request(paymentURL, method: .get, parameters: nil, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.response?.statusCode {
            case 422?:
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false,nil)

            case 200?:
                print("get all events Status code  == \(response.response?.statusCode ?? 0)")
                switch response.result{
                case .failure( let error):
                    print("in fail in gat all events")
                    print(error)
                    completion(false,nil)
                case .success(let value):
                    print("in success in gat all events")
                    let json = JSON(value)
                    let datobj = json["data"]
                    self.defaults.set(json["total"].intValue, forKey: "total")
                    
                    guard let dataArr = datobj.array else{
                        completion(false , [PaymentMethodModel]())
                        return
                    }
                    var results = [PaymentMethodModel]()
                    for data in dataArr {
                        if let data = data.dictionary ,let info = PaymentMethodModel.init(dict: data) {
                            results.append(info)
                        }
                    }
                    completion(true,results)
                }
            default:
                print("get all events Status code  == \(response.response?.statusCode ?? 0)")
                if let dat = response.data {
                    //print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON)
                }
                completion(false,nil)

            }
        }
        
    }
    
    func bookActivity(booking_id:Int,activity_id:Int,event_id:Int,subscribers_num:Int,paid_type:Int,completion : @escaping(_ success: Bool, _ error:String) -> () ){
        
        let parameters : [String : Any] = [
            "booking_id":booking_id,
            "activity_id":activity_id,
            "event_id":event_id,
            "subscribers_num":subscribers_num,
            "paid_type":paid_type,
        ]
        Alamofire.request(bookActivityUrl, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            
            switch response.response?.statusCode {
                
            case 422?:
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false,"server_error".localized())
            case 200?:
                switch response.result
                {
                    
                case .failure( let error):
                    
                    print(error)
                    
                    completion(false,"server_error".localized())
                    
                case .success(let data):
                    
                    let json = JSON(data)
                    print(json)
                    
                   
                    completion(true,"")
                }
            default:
                print("the status code is \(response.response?.statusCode ?? 0)")
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false,"server_error".localized())
            }
            
            
        }
    }
    func deletevent(event_id:Int,completion : @escaping(_ success: Bool, _ error:String) -> () ){
        
        let parameters : [String : Any] = [
            "event_id":event_id,
        ]
        Alamofire.request(deletEventURL, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            
            switch response.response?.statusCode {
                
            case 422?:
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false,"event_deleted_notAllowed".localized())
            case 200?:
                switch response.result
                {
                    
                case .failure( let error):
                    
                    print(error)
                    
                    completion(false,"server_error".localized())
                    
                case .success(let data):
                    
                    let json = JSON(data)
                    print(json)
                    
                    
                    completion(true,"event_deleted".localized())
                }
            default:
                print("the status code is \(response.response?.statusCode ?? 0)")
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false,"server_error".localized())
            }
            
            
        }
    }
    
    func getCities(completion : @escaping(_ success: Bool, _ result:[Cities]?) -> () ){
        
        Alamofire.request(cityUrl, method: .get, parameters: nil, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.response?.statusCode{
                case 200?:
                    switch response.result{
                    case .failure( let error):
                        print(error)
                        completion(false,nil)
                    case .success(let value):
                        let json = JSON(value)
                        // print(json)
                        let citiesData = json["data"]
                        
                        guard let dataArr = citiesData.array else{
                            completion(false , nil)
                            return
                        }
                        var results = [Cities]()
                        for data in dataArr {
                            if let data = data.dictionary ,let info = Cities.init(dict: data) {
                                results.append(info)
                            }
                        }
                        completion(true,results)
                    }
                    
                case 422?:
                    print("the status code is \(response.response?.statusCode ?? 0)")
                    
                default: print("the status code is \(response.response?.statusCode ?? 0)")
                    
                }
        }
        
    }
    
    
    
    
    func getNotifications(page:Int,user_id:Int,completion : @escaping(_ success: Bool, _ result:[NotificationModel]?,_ total:Int) -> () ){
        let parameters:[String:Int] = [
            "user_id":user_id,
            
        ]
        Alamofire.request(notificationURL, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.response?.statusCode {
            case 422?:
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
            case 200?:
                print("get all notificationa Status code  == \(response.response?.statusCode ?? 0)")
                switch response.result{
                case .failure( let error):
                   
                    print(error)
                    completion(false,nil,0)
                case .success(let value):
                    
                    let json = JSON(value)
                    let datobj = json["data"]
                    print(datobj)
                    self.defaults.set(json["total"].intValue, forKey: "totalNotification")
                    
                    guard let dataArr = datobj.array else{
                        completion(false , [NotificationModel](),0)
                        return
                    }
                    var results = [NotificationModel]()
                    for data in dataArr {
                        if let data = data.dictionary ,let info = NotificationModel.init(dict: data) {
                            results.append(info)
                        }
                    }
                    completion(true,results,json["total"].intValue)
                }
            default:
                print("get all notificationa Status code  == \(response.response?.statusCode ?? 0)")
                if let dat = response.data {
                    //print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON)
                }
                completion(false , [NotificationModel](),0)

            }
        }
        
    }
    func getNotificationCellDetails(event_id:Int,user_id:Int,completion : @escaping(_ success: Bool, _ result:EventSDetails?) -> () ){
        let parameters:[String:Int] = [
            "id":event_id,
            "user_id":user_id
        ]
        
        
        
        Alamofire.request(showEventUrl, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.response?.statusCode {
            case 422?:
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false,nil)

            case 200?:
                print("get show event Status code  == \(response.response?.statusCode ?? 0)")
                switch response.result{
                case .failure( let error):
                    print("show fail")
                    print(error)
                    completion(false,nil)
                case .success(let value):
                    print("show success")
                    let json = JSON(value)
                    let datobj = json
                        if let data = datobj.dictionary ,let info = EventSDetails.init(dict: data) {
                            completion(true,info)
                    }
                }
            default:
                print("get all events Status code  == \(response.response?.statusCode ?? 0)")
                if let dat = response.data {
                    //print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON)
                }
                completion(false,nil)

            }
        }
        
    }
    
    func getMyEvents(page:Int,user_id:Int,completion : @escaping(_ success: Bool, _ result:[MyEventsModel]?) -> () ){
        let parameters:[String:Int] = [
            "id":user_id,
            "page":page
        ]
        
        
        
        Alamofire.request(myeventURL, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.response?.statusCode {
            case 422?:
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false , [MyEventsModel]())

            case 200?:
                print("get all events Status code  == \(response.response?.statusCode ?? 0)")
                switch response.result{
                case .failure( let error):
                    print(error)
                    completion(false,nil)
                case .success(let value):
                    let json = JSON(value)
                    let datobj = json["data"]
                    self.defaults.set(json["total"].intValue, forKey: "total")
                    
                    guard let dataArr = datobj.array else{
                        completion(false , [MyEventsModel]())
                        return
                    }
                    var results = [MyEventsModel]()
                    for data in dataArr {
                        if let data = data.dictionary ,let info = MyEventsModel.init(dict: data) {
                            results.append(info)
                        }
                    }
                    completion(true,results)
                }
            default:
                print("get all events Status code  == \(response.response?.statusCode ?? 0)")
                if let dat = response.data {
                    //print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON)
                }
                completion(false , [MyEventsModel]())

            }
        }
        
    }
    
    func getSocial(index:Int,completion : @escaping(_ success: Bool , _ result:String) -> () ){
        
        
        
        Alamofire.request(socialURL, method: .get, parameters: nil, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.response?.statusCode{
                case 200?:
                    print("the status code is \(response.response?.statusCode ?? 0)")
                    switch response.result{
                    case .failure( let error):
                        //print("in fail")
                        //print("the status code is \(response.response?.statusCode ?? 0)")
                        if let dat = response.data {
                            //print("respone data \(dat)")
                            let responseJSON = try? JSON(data: dat)
                            // print(responseJSON ?? 0)
                        }
                        print(error)
                        completion(false,"")
                    case .success(let value):
                        print("in success")
                        let json = JSON(value)
                        print(json)
                        if index == 1 {
                            completion(true,json["facebook"].stringValue)
                        }else if index == 2 {
                            completion(true,json["twitter"].stringValue)
                        }else if index == 3 {
                            completion(true,json["pinterest"].stringValue)
                        }else if index == 4 {
                            completion(true,json["youtube"].stringValue)
                        }else if index == 5 {
                            completion(true,json["instagram"].stringValue)
                        }else{
                            completion(false,"")

                        }
                    }
                    
                case 422?:
                    print("the status code is \(response.response?.statusCode ?? 0)")
                    completion(false,"")
                    
                default:
                    print("the status code is \(response.response?.statusCode ?? 0)")
                    if let dat = response.data {
                        print("respone data \(dat)")
                        let responseJSON = try? JSON(data: dat)
                        print(responseJSON ?? 0)
                    }
                    completion(false,"")
                    
                }
        }
        
    }
    func makeOrder(parameter:Parameters,completion : @escaping(_ success: Bool) -> () ){
       
        var request = URLRequest(url: URL(string: book_order_url)!)
        request.httpMethod = "post"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameter)

        Alamofire.request(request).responseJSON { (response) in
            /*
             if let requestBody = response.request?.httpBody {
             do {
             let jsonArray = try JSONSerialization.jsonObject(with: requestBody, options: [])
             print("Array: \(jsonArray)")
             }
             catch {
             print("Error: \(error)")
             }
             }
             */
            switch response.result{
            case .failure( let error):
                print(error.localizedDescription)
                completion(false)
            case .success(let data):
                print("success in make order")
                if let json = try? JSON(data) {
                    print(json)
                    completion(true)

                }else{
                    completion(false)
                }
            }
        }
        
    }
    func visit(date:String,software_type:Int,completion : @escaping(_ success: Bool , _ result:String) -> () ){
        let parameter:[String:Any] = [
            "date":date,
            "software_type":software_type
        ]
        Alamofire.request(visitURL, method: .post, parameters: parameter, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.response?.statusCode{
                case 200?:
                    print("the status code is \(response.response?.statusCode ?? 0)")
                    switch response.result{
                    case .failure( let error):
                        //print("in fail")
                        //print("the status code is \(response.response?.statusCode ?? 0)")
                        if let dat = response.data {
                            //print("respone data \(dat)")
                            let responseJSON = try? JSON(data: dat)
                            // print(responseJSON ?? 0)
                        }
                        print(error)
                        completion(false,"")
                    case .success(let value):
                        print("in success")
                        let json = JSON(value)
                        completion(true,json["data"]["date"].stringValue)
                        print(json)
                    }
                    
                case 422?:
                    print("the status code is \(response.response?.statusCode ?? 0)")
                    completion(false,"")
                    
                default:
                    print("the status code is \(response.response?.statusCode ?? 0)")
                    if let dat = response.data {
                        print("respone data \(dat)")
                        let responseJSON = try? JSON(data: dat)
                        print(responseJSON ?? 0)
                    }
                    completion(false,"")
                    
                }
        }
        
    }


    func aboutUS(type:Int,completion : @escaping(_ success: Bool , _ result:String) -> () ){
        let parameter = [
            "type":type,
           
        ]
        Alamofire.request(aboutUSURL, method: .post, parameters: parameter, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.response?.statusCode{
                case 200?:
                    print("the status code is \(response.response?.statusCode ?? 0)")
                    switch response.result{
                    case .failure( let error):
                        //print("in fail")
                        //print("the status code is \(response.response?.statusCode ?? 0)")
                        if let dat = response.data {
                            //print("respone data \(dat)")
                            let responseJSON = try? JSON(data: dat)
                            // print(responseJSON ?? 0)
                        }
                        print(error)
                        completion(false,"")
                    case .success(let value):
                        print("in success")
                        let json = JSON(value)
                        print("in api \(json["ar_title"].stringValue)")
                        if self.isArabic{
                            if json["ar_title"].stringValue != nil{
                                completion(true,json["ar_content"].stringValue)
                            }else{
                                completion(true,json["en_content"].stringValue)
                            }
                        }else{
                            if json["en_title"].stringValue != nil{
                            completion(true,json["en_content"].stringValue)
                            }else{
                                completion(true,json["ar_content"].stringValue)

                            }
                        }
                        print(json)
                    }
                    
                case 422?:
                    print("the status code is \(response.response?.statusCode ?? 0)")
                    completion(false,"")
                    
                default:
                    print("the status code is \(response.response?.statusCode ?? 0)")
                    if let dat = response.data {
                        print("respone data \(dat)")
                        let responseJSON = try? JSON(data: dat)
                        print(responseJSON ?? 0)
                    }
                    completion(false,"")
                    
                }
        }
        
    }
    func getCompanyInfo(user_id:Int,completion : @escaping(_ success: Bool, _ result:CompanyInfoModel?) -> () ){
        let parameters:[String:Int] = [
            "user_id":user_id
           
        ]
        
        
        
        Alamofire.request(infoURL, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.response?.statusCode {
            case 422?:
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false , nil)
                
            case 200?:
                print("get all events Status code  == \(response.response?.statusCode ?? 0)")
                switch response.result{
                case .failure( let error):
                    print(error)
                    completion(false,nil)
                case .success(let value):
                    let json = JSON(value)
                    
                    var results:CompanyInfoModel?
                   
                        if let data = json["information"].dictionary ,let info = CompanyInfoModel.init(dict: data) {
                            results = info
                        }
                    
                    completion(true,results)
                }
            default:
                print("get all events Status code  == \(response.response?.statusCode ?? 0)")
                if let dat = response.data {
                    //print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON)
                }
                completion(false , nil)
                
            }
        }
        
    }
}

