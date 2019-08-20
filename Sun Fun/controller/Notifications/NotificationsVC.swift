//
//  NotificationsVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/29/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import SVProgressHUD

class NotificationsVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
  
    

    let user_id = UserDefaults.standard.integer(forKey: "id")
    let isArabic = UserDefaults.standard.bool(forKey: "is_arabic")
    var total = 0
    let user_type = UserDefaults.standard.integer(forKey: "user_type")

    
    
    var allNotifications = [NotificationModel]()
    var page = 1
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    var event_id:Int?
    var status:Int?
    var iD:Int?
    var companyID:Int?
    var userID:Int?
    var notification_id:Int?
    
    override func viewWillAppear(_ animated: Bool) {
        
        allNotifications.removeAll()
        self.page = 1
        if CheckInternet.Connection(){
            getnotifications()
        }else{
            SVProgressHUD.showInfo(withStatus: "no_internet_connection".localized())
            SVProgressHUD.dismiss(withDelay: 3)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "NoteCell", bundle: nil)
        
        
        tableView.register(nib, forCellReuseIdentifier: "NoteCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        
//        if #available(iOS 10.0, *) {
//            tableView.refreshControl = refreshControl
//        } else {
//            tableView.backgroundView = refreshControl
//        }
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if allNotifications.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }else{
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No_data_available".localized()
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("the size off notifications \(allNotifications.count)")
            let lastItem = allNotifications.count - 1
            if indexPath.row == lastItem {
                if total > allNotifications.count {
                    getnotifications()
                }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145.0
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell",for: indexPath) as! NoteCell
        let pos = indexPath.row
        if allNotifications.count > 0 {
        let item = allNotifications[pos]
        if item.action_type == 1 && item.status == 0{
            cell.date.text = TimeHelper().getTimeString(time: item.notification_date!)
            cell.message.text = "for_booking".localized()
        }else if item.action_type == 1 && item.status == 1{
            cell.date.text = TimeHelper().getTimeString(time: item.notification_date!)
            cell.message.text = "accepted_event_booking".localized()
        }else if item.action_type == 1 && item.status == 2{
            cell.date.text = TimeHelper().getTimeString(time: item.notification_date!)
            cell.message.text = "refused_event_booking".localized()
        }else if item.action_type == 4 && item.status == 1{
            cell.date.text = TimeHelper().getTimeString(time: item.notification_date!)
            cell.message.text = "booking_approve".localized()
        }else if item.action_type == 4 && item.status == 2{
            cell.date.text = TimeHelper().getTimeString(time: item.notification_date!)
            cell.message.text = "booking_disapprove".localized()

        }else if item.action_type == 6 && item.status == 1{
            cell.date.text = TimeHelper().getTimeString(time: item.notification_date!)
            cell.message.text = "event_approve".localized()

        }else if item.action_type == 6 && item.status == 2{
            cell.date.text = TimeHelper().getTimeString(time: item.notification_date!)
            cell.message.text = "event_disapprove".localized()

        }else if item.action_type == 5 && item.status == 1{
            cell.date.text = TimeHelper().getTimeString(time: item.notification_date!)
            cell.message.text = "upgrade_approve".localized()

        }else if item.action_type == 5 && item.status == 2{
            cell.date.text = TimeHelper().getTimeString(time: item.notification_date!)
            cell.message.text = "upgrade_disapprove".localized()
        }
        
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pos = indexPath.row
        if allNotifications.count > 0 {
        let item = allNotifications[pos]
        self.event_id = item.event_id!
        self.iD = item.booking_id!
        self.companyID = item.to_id!
        self.userID = item.from_id!
        self.status = item.status!
        self.notification_id = item.id!
        if item.action_type! == 1 && user_type == 2 {
            performSegue(withIdentifier: "showNotificationID", sender: self)
        }
        }
        //
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segue.identifier
        
        if id == "showNotificationID"{
            let des = segue.destination as! NotificationDetailsVC
            des.iD = self.iD!
            des.companyID = self.companyID!
            des.userID = self.userID!
            des.event_id = self.event_id!
            des.status = self.status!
            des.notification_id = self.notification_id!
        }
    }
    func getnotifications(){
        SVProgressHUD.show()
        API().getNotifications(page: page, user_id: user_id) { (success:Bool, result:[NotificationModel]?,tot:Int) in
            SVProgressHUD.dismiss()
            if success{
                SVProgressHUD.dismiss()
                if result != nil{
                    self.total = tot
                    self.allNotifications.append(contentsOf: result!)
                    self.tableView.reloadData()
                    self.page = self.page + 1
                }else{
                SVProgressHUD.showInfo(withStatus: "no_Notifications".localized())
                SVProgressHUD.dismiss(withDelay: 3)
                }
                
            }else{
                print("the description \(result?.description)")
                SVProgressHUD.showError(withStatus: "failed_get_data".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }
        }
    }

}
