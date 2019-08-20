//
//  ConfirmAddEventVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 8/7/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import SVProgressHUD
class ConfirmAddEventVC: UIViewController {
    var Image1: Data?
    var Image2: Data?
    var responsible:String?
    var eventName:String?
    var eventenglishName:String?
    var type_id:Int?
    var cat_id:Int?
    var address:String?
    var latitude:Double?
    var longitude:Double?
    var dateFrome:Int?
    var timeFrom:Int?
    var dateTo:Int?
    var timeTo:Int?
    var eventPrice:String?
    var max_number:String?
    var eventDetailsTV:String?
    var eventEnglishDetailsTV:String?

    var ticketsDetailsTV:String?
    var ticketsEnglishDetailsTV:String?

    let company_id = UserDefaults.standard.integer(forKey: "id")
    
     var event_id:Int?
    
    
    @IBOutlet weak var confirmBTN: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        confirmBTN.roundCorners(cornerRadius: 10.0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submit(_ sender: Any) {
        if Image1 != nil && Image2 != nil
            && responsible != nil && eventName != nil && eventenglishName != nil && type_id != nil && cat_id != nil && address != nil
            && latitude != nil && longitude != nil && dateFrome != nil && timeFrom != nil && dateTo != nil
            && timeTo != nil && eventPrice != nil && max_number != nil && eventDetailsTV != nil && eventEnglishDetailsTV != nil && ticketsDetailsTV != nil
            && ticketsEnglishDetailsTV != nil
            && company_id != nil{
            print("all attribut is good")
            confirmBTN.isEnabled = false

                SVProgressHUD.show()
                AddEvent_API().addEvent(company_id: company_id, ar_title: eventName!, en_title: eventenglishName!, ar_description: eventDetailsTV!, en_description: eventEnglishDetailsTV!, start_at: dateFrome!, end_at: dateTo!, from_time: timeFrom!, to_time: timeTo!, address: address!, image1: Image1!, image2: Image2!, latitude: latitude!, longitude: longitude!, price: eventPrice!, max_number: max_number!, ar_information: ticketsDetailsTV!, en_information: ticketsEnglishDetailsTV!, cat_id: cat_id!, sub_id: type_id!) { (success: Bool, event_id:Int?) in
                   SVProgressHUD.dismiss()
                    if success{
                        
                        self.event_id = event_id!
                    self.alertSendData(message: "event_added".localized(), title: "alarm".localized())
                      
                    }
                }
                
            }else{
             SVProgressHUD.showInfo(withStatus: "not_complete".localized())
            SVProgressHUD.dismiss(withDelay: 2)
                
            }
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segue.identifier
        
        if id == "GoToFiveTOConfirmID"{
            let des = segue.destination as! FiveAddEventVC
            des.event_id = event_id!
            des.dateFrome = dateFrome!
        }
    }
    func alertSendData(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ok".localized(), style: .default, handler: { action in
            self.performSegue(withIdentifier: "GoToFiveTOConfirmID", sender: self)
        })
        let finishAction = UIAlertAction(title: "finish".localized(), style: .default, handler: { action in
            let vc = UIStoryboard(name: "Main", bundle: nil)
            let rootVc = vc.instantiateViewController(withIdentifier: "homeID")
            self.present(rootVc,animated: true,completion: nil)
        })
        alertController.addAction(OKAction)
        alertController.addAction(finishAction)

        self.present(alertController, animated: true, completion: nil)
    }
    }
    


