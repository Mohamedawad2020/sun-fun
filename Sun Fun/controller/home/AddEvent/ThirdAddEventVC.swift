//
//  ThirdAddEventVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/22/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import SVProgressHUD
class ThirdAddEventVC: UIViewController {

 
    // send to four
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
    ////time
    let dateFormatter = DateFormatter()
    let toolbar = UIToolbar()
    
    
    var dateFrome:Int?
    var timeFrom:Int?
    var dateTo:Int?
    var timeTo:Int?
    @IBOutlet weak var timeT: UITextField!
    @IBOutlet weak var dateT: UITextField!
    @IBOutlet weak var dateF: UITextField!
    @IBOutlet weak var timeF: UITextField!
    
    @IBOutlet weak var nextBTN: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        nextBTN.roundCorners(cornerRadius: 5.0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
       
    }
    @IBAction func dateF_BTN(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        let currentDate = Date()
        datePickerView.minimumDate = currentDate
        dateF.inputView = datePickerView
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneclicked))
        toolbar.setItems([doneButton], animated: true)
        dateF.inputAccessoryView = toolbar
        datePickerView.addTarget(self, action: #selector(self.datePicked1), for: UIControl.Event.valueChanged)
    }
    @objc func datePicked1(sender:UIDatePicker) {
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateF.text = dateFormatter.string(from: sender.date)
        dateFrome = Int(sender.date.timeIntervalSince1970)
    }
    @objc func doneclicked(){
        self.view.endEditing(true)
    }
    @IBAction func timeF_BTN(_ sender: UITextField) {
        if !dateF.text!.isEmpty{
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.time
        let currentDate = Date()
        datePickerView.minimumDate = currentDate
        timeF.inputView = datePickerView
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneclicked))
        toolbar.setItems([doneButton], animated: true)
        timeF.inputAccessoryView = toolbar
        datePickerView.addTarget(self, action: #selector(self.timePicked1), for: UIControl.Event.valueChanged)
        }else{
            self.showAlert(message: "EnterStartTimeFirst".localized(), title: "alarm".localized())

        }
    }
    @objc func timePicked1(sender:UIDatePicker) {
        dateFormatter.dateFormat = "h:mm a"
        timeF.text = dateFormatter.string(from: sender.date)
        timeFrom = Int(sender.date.timeIntervalSince1970)
    }
    
    @IBAction func dateT_BTN(_ sender: UITextField) {
        if !dateF.text!.isEmpty{
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        //let currentDate = Date()
        dateFormatter.dateFormat = "MMM d, yyyy"

        datePickerView.minimumDate = dateFormatter.date(from: dateF.text!)!
        dateT.inputView = datePickerView
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneclicked))
        toolbar.setItems([doneButton], animated: true)
        dateT.inputAccessoryView = toolbar
        datePickerView.addTarget(self, action: #selector(self.datePicked2), for: UIControl.Event.valueChanged)
        }else{
            self.showAlert(message: "EnterStartTimeFirst".localized(), title: "alarm".localized())
        }
    }
    @objc func datePicked2(sender:UIDatePicker) {
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateT.text = dateFormatter.string(from: sender.date)
        
        dateTo = Int(sender.date.timeIntervalSince1970)
    }
    @IBAction func timeT_BTN(_ sender: UITextField) {
        if !dateT.text!.isEmpty{
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.time
        let currentDate = Date()
        datePickerView.minimumDate = currentDate
        timeT.inputView = datePickerView
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneclicked))
        toolbar.setItems([doneButton], animated: true)
        timeT.inputAccessoryView = toolbar
        datePickerView.addTarget(self, action: #selector(self.timePicked2), for: UIControl.Event.valueChanged)
        }else{
            self.showAlert(message: "enterEndAtFirst".localized(), title: "alarm".localized())

        }
    }
    @objc func timePicked2(sender:UIDatePicker) {
        dateFormatter.dateFormat = "h:mm a"
        timeT.text = dateFormatter.string(from: sender.date)
        timeTo = Int(sender.date.timeIntervalSince1970)
    }
    
    

    @IBAction func next(_ sender: Any) {
        if dateF.text!.isEmpty && timeF.text!.isEmpty && dateT.text!.isEmpty && timeT.text!.isEmpty{
            SVProgressHUD.showInfo(withStatus: "all_fields_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if dateF.text!.isEmpty{
            SVProgressHUD.showInfo(withStatus: "startDateRequired".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if timeF.text!.isEmpty{
            SVProgressHUD.showInfo(withStatus: "starttimeRequired".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if dateT.text!.isEmpty{
            SVProgressHUD.showInfo(withStatus: "endDateRequired".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if timeT.text!.isEmpty{
            SVProgressHUD.showInfo(withStatus: "endtimeRequired".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else{
            performSegue(withIdentifier: "ToFour", sender: self)

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segue.identifier
        
        if id == "ToFour"{
            let des = segue.destination as! FourAddEventVC
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
        }
    }
}

