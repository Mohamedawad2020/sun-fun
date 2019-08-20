//
//  Myorder+API.swift
//  Sun Fun
//
//  Created by arab devolpers on 8/4/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class MyOrder_API{
    let defaults = UserDefaults.standard
    func getMyOrders(url:String,user_id: Int,completion : @escaping(_ success: Bool, _ result:[MyOrderModel.Booking]?) -> () ){
        let parameter = [
            "id":user_id
        ]
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.response?.statusCode{
                case 200?:
                    switch response.result{
                    case .failure( let error):
                        print(error)
                        if let dat = response.data {
                            print(dat)
                            let responseJSON = try? JSON(data: dat)
                            print(responseJSON ?? 0)
                        }
                        completion(false,nil)
                    case .success(let value):
                        let json = JSON(value)
                           print(json)
                        let ordersData = json["data"]
                        
                        guard let dataArr = ordersData.array else{
                            completion(false , nil)
                            return
                        }
                        var results = [MyOrderModel.Booking]()
                        for data in dataArr {
                            if let data = data.dictionary ,let info = MyOrderModel.Booking.init(dict: data) {
                                results.append(info)
                            }
                        }
                        completion(true,results)
                    }
                    
                case 422?:
                    print("the status code is \(response.response?.statusCode ?? 0)")
                    if let dat = response.data {
                        print(dat)
                        let responseJSON = try? JSON(data: dat)
                        print(responseJSON ?? 0)
                    }
                    completion(false,nil)
                case 201?:
                    print("the status code is \(response.response?.statusCode ?? 0)")
                    if let dat = response.data {
                        print(dat)
                        let responseJSON = try? JSON(data: dat)
                        print(responseJSON ?? 0)
                    }
                    completion(true,nil)

                default: print("the status code is \(response.response?.statusCode ?? 0)")
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false,nil)

                }
        }
        
    }
    func getDataBy_QRCODE(booking_code: String,completion : @escaping(_ success: Bool, _ result:MyTicketModel.Booking?, _ result:[MyTicketModel.booking_details]?) -> () ){
        let parameter = [
            "booking_code":booking_code
        ]
        
        Alamofire.request(getDataByQRCode_URL, method: .post, parameters: parameter, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.response?.statusCode{
                case 200?:
                    switch response.result{
                    case .failure( let error):
                        print(error)
                        if let dat = response.data {
                            print(dat)
                            let responseJSON = try? JSON(data: dat)
                            print(responseJSON ?? 0)
                        }
                        completion(false,nil,nil)
                    case .success(let value):
                        let json = JSON(value)
                        print(json)
                        let bookingData = json["booking"]
                        let DetailsData = json["booking_details"]

                        
                        var resultBooking:MyTicketModel.Booking!
                        
                            if let data = bookingData.dictionary ,let info = MyTicketModel.Booking.init(dict: data) {
                                resultBooking = info
                            }
                        guard let dataArr = DetailsData.array else{
                            completion(true, resultBooking,nil)
                            return
                        }
                        var resultDetails = [MyTicketModel.booking_details]()
                        for data in dataArr{
                        if let data = data.dictionary ,let info = MyTicketModel.booking_details.init(dict: data) {
                            resultDetails.append(info)
                        }
                        }
                        
                        completion(true,resultBooking,resultDetails)
                    }
                    
                case 422?:
                    print("the status code is \(response.response?.statusCode ?? 0)")
                    if let dat = response.data {
                        print(dat)
                        let responseJSON = try? JSON(data: dat)
                        print(responseJSON ?? 0)
                    }
                    completion(false,nil,nil)
                case 201?:
                    print("the status code is \(response.response?.statusCode ?? 0)")
                    if let dat = response.data {
                        print(dat)
                        let responseJSON = try? JSON(data: dat)
                        print(responseJSON ?? 0)
                    }
                    completion(true,nil,nil)
                    
                default: print("the status code is \(response.response?.statusCode ?? 0)")
                if let dat = response.data {
                    print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
                completion(false,nil,nil)
                    
                }
        }
        
    }
    
}
