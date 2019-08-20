//
//  BookoingActivityVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/25/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import iOSDropDown
import SVProgressHUD
import Alamofire
class BookoingActivityVC: UIViewController {

    
    var booking_id: Int?
    var activity_id:Int?
    var event_id :Int?
    var subscribers_num:Int?
    var paid_type:Int?
    
    var parameters:Parameters = [String:Any]()

    @IBOutlet weak var paidMethod: DropDown!
    @IBOutlet weak var numberOfIndividualsTF: UITextField!
    @IBOutlet weak var phoneNumberL: UILabel!
    @IBOutlet weak var emailL: UILabel!
    @IBOutlet weak var nameL: UILabel!
    let name = UserDefaults.standard.string(forKey: "name")
    let email = UserDefaults.standard.string(forKey: "email")
    let phone = UserDefaults.standard.string(forKey: "phone")

    let user_id = UserDefaults.standard.integer(forKey: "id")
    let isArabic = UserDefaults.standard.bool(forKey: "is_arabic")
   
    var paymentData = [PaymentMethodModel]()
    var ar_title = [String]()
    var en_title = [String]()
    var payment_IDs = [Int]()
    var pay_id:Int?
   
    override func viewWillAppear(_ animated: Bool) {
        getAuthData()
        getPaymentsMethod()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func getAuthData(){
        nameL.text = name
        emailL.text = email
        phoneNumberL.text = phone
    }
    
    func getPaymentsMethod(){
        
        API().paymentMethod { (success: Bool, result: [PaymentMethodModel]?) in
            if success{
                self.paymentData = result!
                if self.isArabic{
                    for item in self.paymentData{
                        self.ar_title.append(item.ar_title!)
                        self.paidMethod.optionArray = self.ar_title
                        self.payment_IDs.append(item.id!)
                        self.paidMethod.optionIds = self.payment_IDs
                        self.paidMethod.didSelect(completion: { (selectedItem, index, id) in
                            self.paidMethod.text = selectedItem
                            self.pay_id = id
                        })
                    }
                }else{
                    for item in self.paymentData{
                        self.en_title.append(item.en_title!)
                        self.paidMethod.optionArray = self.en_title
                        self.payment_IDs.append(item.id!)
                        self.paidMethod.optionIds = self.payment_IDs
                        self.paidMethod.didSelect(completion: { (selectedItem, index, id) in
                            self.paidMethod.text = selectedItem
                            self.pay_id = id
                        })
                    }
                }
                
                
            }else{
                SVProgressHUD.showError(withStatus: "failed_get_data".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }
        }
    }
    
    @IBAction func revservBTn(_ sender: Any) {
        
        if numberOfIndividualsTF.text!.isEmpty{
            SVProgressHUD.showInfo(withStatus: "ivalidsubScriber".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        } else if paidMethod.text!.isEmpty{
            SVProgressHUD.showInfo(withStatus: "invalidpayedMethod".localized())
            SVProgressHUD.dismiss(withDelay: 2)

        }else if numberOfIndividualsTF.text!.isEmpty && paidMethod.text!.isEmpty{
            SVProgressHUD.showInfo(withStatus: "all_fields_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)

        }else{
         subscribers_num = Int(numberOfIndividualsTF.text!)!
        API().bookActivity(booking_id :28, activity_id: activity_id!, event_id: event_id!, subscribers_num: subscribers_num!, paid_type: paid_type!) { (success:Bool, error:String) in
            if success{
                print("the activity reserved success")
                SVProgressHUD.showInfo(withStatus: "activitySuccess".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }else{
                SVProgressHUD.showError(withStatus: "failed_get_data".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }
        }
            
        }
    }
    
}
