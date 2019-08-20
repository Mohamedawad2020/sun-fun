//
//  FourAddEventVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/22/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import SVProgressHUD
class FourAddEventVC: UIViewController {
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
    
    
    
    
    @IBOutlet weak var nextBTN: UIButton!
    @IBOutlet weak var ticketsDetailsTV: UITextView!
    @IBOutlet weak var ticketEnglishDeatails: UITextView!
    @IBOutlet weak var eventDetailsTV: UITextView!
    @IBOutlet weak var eventEnglishDetails: UITextView!
    @IBOutlet weak var maxNumber: UITextField!
    @IBOutlet weak var price: UITextField!
    override func viewWillAppear(_ animated: Bool) {
        nextBTN.roundCorners(cornerRadius: 5.0)
        ticketsDetailsTV.roundCorners(cornerRadius: 10.0)
        ticketEnglishDeatails.roundCorners(cornerRadius: 10.0)
        eventDetailsTV.roundCorners(cornerRadius: 10.0)
        eventEnglishDetails.roundCorners(cornerRadius: 10.0)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func next(_ sender: Any) {
        
        if price.text!.isEmpty && maxNumber.text!.isEmpty && eventDetailsTV.text!.isEmpty && eventEnglishDetails.text!.isEmpty && ticketsDetailsTV.text!.isEmpty && ticketEnglishDeatails.text!.isEmpty{
            
            SVProgressHUD.showInfo(withStatus: "all_fields_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if price.text!.isEmpty{
            SVProgressHUD.showInfo(withStatus: "eventPriceRequired".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if maxNumber.text!.isEmpty{
            SVProgressHUD.showInfo(withStatus: "eventmaxNumberRequired".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if eventDetailsTV.text!.isEmpty{
            SVProgressHUD.showInfo(withStatus: "eventEventDetailsRequired".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if eventEnglishDetails.text!.isEmpty{
            SVProgressHUD.showInfo(withStatus: "eventEventEnglishDetailsRequired".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if ticketsDetailsTV.text!.isEmpty{
            SVProgressHUD.showInfo(withStatus: "eventTicketDetailsRequired".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if ticketEnglishDeatails.text!.isEmpty{
            SVProgressHUD.showInfo(withStatus: "eventTicketEnglishDetailsRequired".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else{
            
            performSegue(withIdentifier: "confirmAddEventID", sender: self)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segue.identifier
        
        if id == "confirmAddEventID"{
            let des = segue.destination as! ConfirmAddEventVC
            des.cat_id = cat_id!
            des.type_id = type_id!
            des.Image1 = Image1!
            des.Image2 = Image2!
            des.eventName = eventName!
            des.eventenglishName = eventenglishName!
            des.responsible = responsible!
            des.address = address
            des.latitude = latitude!
            des.longitude = longitude!
            des.dateFrome = dateFrome!
            des.timeFrom = timeFrom!
            des.dateTo = dateTo!
            des.timeTo = timeTo!
          //
            des.eventPrice = price.text!.englishNumbers()!
            des.max_number = maxNumber.text!.englishNumbers()!
            des.eventDetailsTV = eventDetailsTV.text!
            des.eventEnglishDetailsTV = eventEnglishDetails.text!
            des.ticketsDetailsTV = ticketsDetailsTV.text!
            des.ticketsEnglishDetailsTV = ticketEnglishDeatails.text!
        }
    }
    
    

}
