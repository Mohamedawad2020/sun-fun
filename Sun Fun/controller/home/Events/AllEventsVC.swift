//
//  AllEventsVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/17/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import iOSDropDown
import SVProgressHUD
import SwiftyJSON
import Kingfisher
import UserNotifications
class AllEventsVC: UIViewController, UITableViewDelegate,UITableViewDataSource, UNUserNotificationCenterDelegate{

    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var eventTypes: DropDown!
    @IBOutlet weak var categoryTF: DropDown!
    //event
    var eventTypesData = [EventTypes.types]()
    var ar_title = [String]()
    var en_title = [String]()
    var event_Type_IDS = [Int]()
    var event_Type:Int?
    var flag = true
    var search = true
    // pagination
    var page = 1

    /// category
    var categoryData = [EventTypes.Event_sub_category]()
    var ar_title_category = [String]()
    var en_title_category = [String]()
    var category_ids = [Int]()
    let user_id = UserDefaults.standard.integer(forKey: "id")
    let isArabic = UserDefaults.standard.bool(forKey: "is_arabic")
    let total = UserDefaults.standard.integer(forKey: "total")
    var eventResult = [EventTypes.Event_sub_category]()
    var categoryArray = [[JSON]]()
    var allEvents = [EventSDetails]()
    let dateFormatter = DateFormatter()
    var date:Date?
    
    var id:Int?
    var cat_id:Int?
    
    
    
    
    var sendData = [Int:String]()
    var event_id :Int?
    var company_id:Int?
 
    var activityresult = [Activities]()

    var index:Int?
    
    
    var testDate = true
    override func viewWillAppear(_ animated: Bool) {
        sendData.removeAll()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let sendDate = dateFormatter.string(from: Date())
        let visitDate = Int(dateFormatter.date(from: sendDate)!.timeIntervalSince1970)
        
        if visitDate != UserDefaults.standard.integer(forKey: "TestDate"){
            checkVisit()
        }
        allEvents.removeAll()
        self.page = 1
        index = 0
        if CheckInternet.Connection(){
        getEvents()
        }else{
            SVProgressHUD.showInfo(withStatus: "no_internet_connection".localized())
            SVProgressHUD.dismiss(withDelay: 3)
        }
    }
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            
        })
        if CheckInternet.Connection(){
            load_event_types()
        }else{
            SVProgressHUD.showInfo(withStatus: "no_internet_connection".localized())
            SVProgressHUD.dismiss(withDelay: 3)
        }
        
        let nib = UINib(nibName: "eventCell", bundle: nil)
        
        
        eventsTable.register(nib, forCellReuseIdentifier: "eventCell")
        
        eventsTable.delegate = self
        eventsTable.dataSource = self
        
    }
    func checkVisit(){
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let sendDate = dateFormatter.string(from: Date())
        
        API().visit(date: sendDate, software_type: 3) { (success:Bool, dat:String) in
            if success{
                self.dateFormatter.dateFormat = "MM-dd-yyyy"
                let x = Int(self.dateFormatter.date(from: dat)!.timeIntervalSince1970)
                
                
                UserDefaults.standard.set(x, forKey: "TestDate")
                print("date updated")
                
            }else{
                print("fail to get date")
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if search{
        print("the size off events \(allEvents.count)")
        if flag{
        let lastItem = allEvents.count - 1
        if indexPath.row == lastItem {
            if total > allEvents.count {
                //self.page = self.page + 1
                //eventsTable.reloadData()
               // refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
                getEvents()
            }
        }
        }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 325.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell",for: indexPath) as! eventCell
        let pos = indexPath.row
        if allEvents.count > 0{
        let item = allEvents[pos]
        if item.image1 != nil{
            cell.imageEvent.kf.setImage(with: URL(string:uploadEventImageURL + item.image1!),options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
                ])
            cell.imageEvent.contentMode = .scaleToFill
        } else if item.image2 != nil{
            if item.image1 != nil{
                cell.imageEvent.kf.setImage(with: URL(string:uploadEventImageURL + item.image2!),options: [
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage
                    ])
                cell.imageEvent.contentMode = .scaleToFill
        }
        }
        if isArabic{
            cell.eventName.text = item.ar_title!
        }else{
            
            cell.eventName.text = item.en_title!
           
        }
        cell.joinUsNumber.text = "\(item.booking_number!) \("person".localized())"
        company_id = item.company_id!
        event_id = item.id!
        let max = item.max_number!
        let num = item.booking_number!
        let ticket = max - num
        cell.ticketRemaining.text = "\(ticket) \("Tikets".localized())"
        
      
        
        cell.price.text = "\(item.price!) \("SR".localized())"
        
        
        /// convert timestamp to date as an forrmate
            dateFormatter.dateFormat = "MMM d"
            date = Date(timeIntervalSince1970: TimeInterval(item.start_at!))
            
            cell.dateLable.text = "\(dateFormatter.string(from: date!))"
       
        
        cell.bookBTN.addTarget(self, action: #selector(MyEventsVC.editTaped(sender:)), for: .touchUpInside)
        cell.bookBTN.tag = pos
        }
        return cell
    }
    
    @objc func editTaped(sender: UIButton) {
        print("the tag is \(sender.tag)")
        index = sender.tag
        if allEvents[index!].company_id! != user_id {
        if allEvents.count > 0{
        
        getEventActivities()
        self.performSegue(withIdentifier: "EventBookingID", sender: self)
        }
        }
    }
    func getEventActivities(){
        let json = allEvents[index!].activities
        for data in json!{
            if let data = data.dictionary ,let subCategoryData = Activities.init(dict: data) {
                self.activityresult.append(subCategoryData)
            }
        }
        print("act \(activityresult.count)")
        for item in activityresult{
            if isArabic{
            sendData[item.id] = item.ar_title!
            }else{
                sendData[item.id] = item.ar_title!
            }
        }
        
    }
    var indexpath:Int?
    // selected cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexpath = indexPath.row
        performSegue(withIdentifier: "EventDetails", sender: indexPath.row)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segue.identifier
        
        if id == "EventDetails"{
            if allEvents.count > 0 {
            let des = segue.destination as! BookingEventWithDetailsVC
            des.eventDetails = self.allEvents[indexpath!]
                
           print("the Send Data \(self.allEvents[indexpath!])")
            }
        }else if id == "EventBookingID" {
            if allEvents.count > 0{
                let des = segue.destination as! BookingEventVC
                des.receviedData = sendData
                des.event_id = event_id!
                des.company_id = company_id!
                print("send data \(sendData.description)")
                
            }
        }
    }
   
    func getEvents(){
        
        SVProgressHUD.show()
        API().getAllEvents(page:page,user_id:user_id) { (success:Bool, result:[EventSDetails]?) in
            SVProgressHUD.dismiss()
            if success{
                print("the result of all events is \(result?.count)")
                if result != nil {
                    self.flag = true
                    self.allEvents.append(contentsOf: result!)
                    self.eventsTable.reloadData()
                    self.page = self.page + 1
                }else{
                    SVProgressHUD.showInfo(withStatus: "no_events".localized())
                    SVProgressHUD.dismiss(withDelay: 3)
                }
            }else{
                print("the description \(result?.description)")
                SVProgressHUD.showError(withStatus: "failed_get_data".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }
        }
        
    }
    func searchByCategory(){
        if CheckInternet.Connection(){
        SVProgressHUD.show()
            API().searchByCategory(user_id:user_id,id: id!, cat_id: cat_id!) { (success:Bool, result:[EventSDetails]?) in
            SVProgressHUD.dismiss()
            if success{
                self.search = false
                print("the result size \(result?.count)")
                self.allEvents = result!
                self.eventsTable.reloadData()
                
            }else{
                SVProgressHUD.showError(withStatus: "failed_get_data".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }
        }
       
        }else{
            SVProgressHUD.showInfo(withStatus: "no_internet_connection".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }
    }
    
    
    
    func load_event_types() {
        categoryArray.removeAll()
        SVProgressHUD.show()
        API().get_Events_Type{ (success:Bool, result1:[EventTypes.types]?) in
            SVProgressHUD.dismiss()
            if success{
                
                self.eventTypesData = result1!
                self.categoryArray.removeAll()
                print("the event data \(self.eventTypesData)")
                if self.isArabic{
                    self.event_Type_IDS.removeAll()
                    self.ar_title.removeAll()
                    for item in self.eventTypesData {
                        self.categoryArray.append(item.sub_categories)
                        self.ar_title.append(item.ar_title!)
                        self.eventTypes.optionArray = self.ar_title
                        self.event_Type_IDS.append(item.id!)
                        
                        self.eventTypes.optionIds = self.event_Type_IDS
                        self.eventTypes.didSelect(completion: { (selectedItem, index, id) in
                            self.eventTypes.text = selectedItem
                            self.cat_id = id
                            // make subcaregory empty
                            self.categoryTF.text = nil
                            self.ar_title_category.removeAll()
                            self.category_ids.removeAll()
                            self.en_title_category.removeAll()
                            ////
                            print("the id for Category is \(id)")
                            print("the categoy size is \(self.categoryArray.count)")
                            let json = self.categoryArray[index]
                            
                            
                            print("the json count is \(json.count)")
                            if json.count > 0 {
                                
                                for data in json{
                                    if let data = data.dictionary ,let subCategoryData = EventTypes.Event_sub_category.init(dict: data) {
                                        self.eventResult.append(subCategoryData)
                                    }
                                    
                                }
                                self.flag = false
                                self.load_sub_categorys(result: self.eventResult)
                                self.eventResult.removeAll()
                            }else{
                                self.categoryTF.text = nil
                                self.categoryTF.optionArray = []
                                self.categoryTF.optionIds = []
                                self.ar_title_category.removeAll()
                            }
                        })
                        // id
                        
                    }
                }else {
                    self.event_Type_IDS.removeAll()
                    self.en_title.removeAll()
                    for item in self.eventTypesData {
                        self.categoryArray.append(item.sub_categories)
                        print(item.sub_categories.count)
                        self.en_title.append(item.en_title!)
                        self.eventTypes.optionArray = self.en_title
                        self.event_Type_IDS.append(item.id!)
                        self.eventTypes.optionIds = self.event_Type_IDS
                        self.eventTypes.didSelect(completion: { (selecteditem, index, id) in
                            self.eventTypes.text = selecteditem
                            self.cat_id = id
                            print("the id for Category is \(id)")
                            let json = self.categoryArray[index]
                            
                            
                            print("the json count is \(json.count)")
                            if json.count > 0 {
                                for data in json{
                                    if let data = data.dictionary ,let subCategoryData = EventTypes.Event_sub_category.init(dict: data) {
                                        self.eventResult.append(subCategoryData)
                                    }
                                    
                                }
                                self.flag = false
                                self.load_sub_categorys(result: self.eventResult)
                                self.eventResult.removeAll()
                            }else{
                                
                                self.categoryTF.text = nil
                                self.categoryTF.optionArray.removeAll()
                                self.categoryTF.optionIds?.removeAll()
                                self.en_title_category.removeAll()
                               
                            }
                        })
                        // id
                        
                    }
                    print("the categoy size is \(self.categoryArray.count)")

                    
                }
                self.eventTypes.showList()
                self.eventTypes.hideList()
            }else{
                SVProgressHUD.showError(withStatus: "get_data_error".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }
        }
    }
    func load_sub_categorys(result:[EventTypes.Event_sub_category]?) {
       self.categoryData.removeAll()
        self.categoryTF.text = nil
        self.ar_title_category.removeAll()
        self.category_ids.removeAll()
        self.en_title_category.removeAll()
        self.categoryData = result!
        if self.categoryData.count > 0 {
        if self.isArabic{
            
            
            for item  in self.categoryData {
            
                self.ar_title_category.append(item.ar_title!)
                self.categoryTF.optionArray = self.ar_title_category
                self.category_ids.append(item.id!)
                self.categoryTF.optionIds = self.category_ids
                self.categoryTF.didSelect(completion: { (selectedItem, index, id) in
                    self.categoryTF.text = selectedItem
                    
                    self.id = id
                    self.searchByCategory()
                    print("the id for subCategory is \(id)")
                })
                // id
                
            }
        }else {
           
            
            for item in self.categoryData {
                self.en_title_category.append(item.en_title!)
                self.categoryTF.optionArray = self.en_title_category
                self.category_ids.append(Int(item.id!))
                self.categoryTF.optionIds = self.category_ids
                self.categoryTF.didSelect(completion: { (selecteditem, index, id) in
                    self.categoryTF.text = selecteditem
                    self.id = id
                    self.searchByCategory()
                    print("the id for subCategory is \(id)")
                })
                // id
                
            }
            }
            
        }else{
            
        }
        self.categoryTF.showList()
        self.categoryTF.hideList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
  
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
  
}

