//
//  BookingEventVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/25/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import iOSDropDown
import SVProgressHUD
import Alamofire
class BookingEventVC: UIViewController {

    @IBOutlet weak var paymentMethod: DropDown!
    var name = UserDefaults.standard.string(forKey: "name")
    var phone = UserDefaults.standard.string(forKey: "phone")
    var email = UserDefaults.standard.string(forKey: "email")
    @IBOutlet weak var numberOfIndividuals: UITextField!
    @IBOutlet weak var phonenumberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var activitiesTF: DropDown!
    //////// //////// //////// //////// ////////
    var parameters = [String : Any]()
    var param:Parameters = [String:Any]()
     //////// //////// //////// //////// ////////
    @IBOutlet weak var numberOfIndividualsForActivity: UITextField!
    
    var receviedData = [Int:String]()
    //var midData = [String:Int]()
    var selectedactivities = [[String:Int]]()

    var event_id :Int?
    var company_id:Int?
    
    var paymentData = [PaymentMethodModel]()
    var ar_title = [String]()
    var en_title = [String]()
    var payment_IDs = [Int]()
    var pay_id:Int?
    
    var activity_name = [String]()
    var activity_ids = [Int]()
    var activityID:Int?
    
    
    let user_id = UserDefaults.standard.integer(forKey: "id")
    let isArabic = UserDefaults.standard.bool(forKey: "is_arabic")
    override func viewWillAppear(_ animated: Bool) {
        if receviedData.isEmpty{
            activitiesTF.isUserInteractionEnabled = false
            numberOfIndividualsForActivity.isUserInteractionEnabled = false
        }
        nameTF.text = name!
        phonenumberTF.text = phone!
        emailTF.text = email!
        nameTF.isEnabled = false
        phonenumberTF.isEnabled = false
        emailTF.isEnabled = false
        activity_name.removeAll()
        activity_ids.removeAll()
        selectedactivities.removeAll()
        if isArabic{
            ar_title.removeAll()
            
        }else{
            en_title.removeAll()
        }
        payment_IDs.removeAll()
        parameters.removeAll()
        getActivities()
        getPaymentsMethod()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    
    func getActivities(){
       
        for (key,value) in receviedData{
            activity_name.append(value)
            activitiesTF.optionArray = activity_name
            activity_ids.append(key)
            activitiesTF.optionIds = activity_ids
            self.activitiesTF.didSelect(completion: { (selectedItem, index, id) in
                
                self.activitiesTF.text = selectedItem
                self.activityID = id
                
                self.activityAlert()
                
            })
        }

    }
    func activityAlert(){
        let alert = UIAlertController(title: "alarm".localized(), message: "enterNewPassword".localized(), preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "enterNumber".localized()
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            if !textField!.text!.isEmpty{
            self.numberOfIndividualsForActivity.text = textField!.text
                let midData:[String:Int] = [
                    "subscribers_num":Int(textField!.text!)!,
                    "activity_id": self.activityID!
                ]
            self.selectedactivities.append(midData)
            }
            self.param["bookingDetails"] = self.selectedactivities
            print("the result \(self.selectedactivities.description)")

        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
       
    }
    
    func getPaymentsMethod(){
        
        API().paymentMethod { (success: Bool, result: [PaymentMethodModel]?) in
            if success{
                self.paymentData = result!
                if self.isArabic{
                    for item in self.paymentData{
                        self.ar_title.append(item.ar_title!)
                        self.paymentMethod.optionArray = self.ar_title
                        self.payment_IDs.append(item.id!)
                        self.paymentMethod.optionIds = self.payment_IDs
                        self.paymentMethod.didSelect(completion: { (selectedItem, index, id) in
                            self.paymentMethod.text = selectedItem
                            self.pay_id = id
                        })
                    }
                }else{
                    for item in self.paymentData{
                        self.en_title.append(item.en_title!)
                        self.paymentMethod.optionArray = self.en_title
                        self.payment_IDs.append(item.id!)
                        self.paymentMethod.optionIds = self.payment_IDs
                        self.paymentMethod.didSelect(completion: { (selectedItem, index, id) in
                            self.paymentMethod.text = selectedItem
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
  
    @IBAction func reserveBTN(_ sender: Any) {
        
        if nameTF.text!.isEmpty && emailTF.text!.isEmpty && phonenumberTF.text!.isEmpty && numberOfIndividuals.text!.isEmpty   && paymentMethod.text!.isEmpty{
            SVProgressHUD.show(withStatus: "all_fields_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if  nameTF.text!.isEmpty{
            SVProgressHUD.showInfo(withStatus: "username_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if emailTF.text!.isEmpty{
            SVProgressHUD.showInfo(withStatus: "email_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if phonenumberTF.text!.isEmpty {
            SVProgressHUD.showInfo(withStatus: "phone_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if nameTF.text!.count < 4 {
            SVProgressHUD.showInfo(withStatus: "username_invalid".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if !Validaton.isValidEmailAddress(emailAddressString: emailTF.text!){
            SVProgressHUD.showInfo(withStatus: "email_invalid".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if phonenumberTF.text!.count < 10 {
            SVProgressHUD.showInfo(withStatus: "phone_invalid".localized())
            SVProgressHUD.dismiss(withDelay: 2)
            
        }else if numberOfIndividuals.text!.isEmpty {
            SVProgressHUD.showInfo(withStatus: "number_of_individual_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if paymentMethod.text!.isEmpty{
            SVProgressHUD.showInfo(withStatus: "payment_invalid".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else{
           
          
            param["company_id"] = company_id!
            param["user_id"] = user_id
            param["event_id"] = event_id!
            param["subscribers_num"] = Int(numberOfIndividuals.text!)!
            param["paid_type"] = pay_id!
            

            API().makeOrder(parameter: param) { (success:Bool) in
                if success{
                    self.alertdone(message: "success_booking".localized(), title: "alarm".localized())
                    print("suc success")
                }else{
                    print("fai faild")
                }
            }
        }
        
    }
    }
struct User : Encodable, Decodable {
    let company_id : Int
    let user_id : Int
    let event_id : Int
    let subscribers_num : Int
    let paid_type : Int
    let bookingDetails : [[String:Int]]
}
