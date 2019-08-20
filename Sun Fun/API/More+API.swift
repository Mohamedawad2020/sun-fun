//
//  More+API.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/28/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class More_API{
     let defaults = UserDefaults.standard
    func contactUs(fname:String,email:String,subject:String,message:String,completion : @escaping(_ success: Bool, _ error:String) -> () ){
        
        let parameters : [String : Any] = [
            "fname":fname,
            "email":email,
            "subject":subject,
            "message":message,
            
        ]
        Alamofire.request(contactUsURL, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            
            switch response.response?.statusCode {
                
            case 422?:
                print("the status code is \(response.response?.statusCode ?? 0)")
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false,"")

            case 200?:
                print("the status code is \(response.response?.statusCode ?? 0)")
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
    func bankAccount(completion : @escaping(_ success: Bool, _ result:[BankAccountModel]?) -> () ){
        
      
        Alamofire.request(bankAccountURL, method: .get, parameters: nil, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            
            switch response.response?.statusCode {
                
            case 422?:
                print("the status code is \(response.response?.statusCode ?? 0)")
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false,nil)
                
            case 200?:
                print("the status code is \(response.response?.statusCode ?? 0)")
                switch response.result
                {
                    
                case .failure( let error):
                    
                    print(error)
                    
                    completion(false,nil)
                    
                case .success(let data):
                    
                    let json = JSON(data)
                    print(json)
                    guard let dataArr = json["data"].array else{
                        completion(false , [BankAccountModel]())
                        return
                    }
                    var results = [BankAccountModel]()
                    for data in dataArr {
                        if let data = data.dictionary ,let info = BankAccountModel.init(dict: data) {
                            results.append(info)
                        }
                    }
                    completion(true,results)
                }
            default:
                print("the status code is \(response.response?.statusCode ?? 0)")
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false,nil)
                
            }
            
            
        }
    }
}
