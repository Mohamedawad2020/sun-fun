//
//  MyEventsVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/30/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Kingfisher
class MyEventsVC: UIViewController , UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var eventsTable: UITableView!
   
    //event
    
    // pagination
    var page = 1
    var event_id:Int?
    /// category
    let responsible = UserDefaults.standard.string(forKey: "responsible")
    let user_id = UserDefaults.standard.integer(forKey: "id")
    let isArabic = UserDefaults.standard.bool(forKey: "is_arabic")
    var total = 0
    var allEvents = [MyEventsModel]()
    let dateFormatter = DateFormatter()
    var date:Date?
    override func viewWillAppear(_ animated: Bool) {
        allEvents.removeAll()
        self.page = 1
        if CheckInternet.Connection(){
            SVProgressHUD.show()
            getEvents()

        }else{
            SVProgressHUD.showInfo(withStatus: "no_internet_connection".localized())
            SVProgressHUD.dismiss(withDelay: 3)
        }
    }
    
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let nib = UINib(nibName: "MyCell", bundle: nil)
        
        
        eventsTable.register(nib, forCellReuseIdentifier: "MyCell")
        
        eventsTable.delegate = self
        eventsTable.dataSource = self
        
        
        
        
//        if #available(iOS 10.0, *) {
//            eventsTable.refreshControl = refreshControl
//        } else {
//            eventsTable.backgroundView = refreshControl
//        }
    }
    //    @objc func refresh(_ refreshControl: UIRefreshControl) {
    //        getEvents()
    //        refreshControl.endRefreshing()
    //    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("the size off events \(allEvents.count)")
        if allEvents.count > 0 {
        let lastItem = allEvents.count - 1
            if indexPath.row == lastItem {
                if total > allEvents.count {
                    SVProgressHUD.show()
                    getEvents()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell",for: indexPath) as! MyCell
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
                cell.eventDescription.text  = item.ar_description!
            }else{
                
                cell.eventName.text = item.ar_title!
                cell.eventDescription.text  = item.ar_description!
                
            }
          
            
            dateFormatter.dateFormat = "MMM d, yyyy"
            date = Date(timeIntervalSince1970: TimeInterval(item.start_at!))
            cell.eventDate.text = "\(dateFormatter.string(from: date!))"
            
            cell.eventOrganizer.text = responsible!
           
            /// convert timestamp to date as an forrmate
            
            dateFormatter.dateFormat = "h:mm a"
            date = Date(timeIntervalSince1970: TimeInterval(item.from_time!))
            cell.fromTime.text = "\(dateFormatter.string(from: date!))"
            
            date = Date(timeIntervalSince1970: TimeInterval(item.to_time!))
            cell.toTime.text = "\(dateFormatter.string(from: date!))"
            
         
            cell.bookBTN.addTarget(self, action: #selector(MyEventsVC.editTaped(sender:)), for: .touchUpInside)
            cell.bookBTN.tag = pos
            
            cell.removeBTN.addTarget(self, action: #selector(MyEventsVC.removeTaped(sender:)), for: .touchUpInside)
            cell.removeBTN.tag = pos
        }
        
        return cell
    }
    
    // MARK: - Actions
    
    @objc func editTaped(sender: UIButton) {
        // Fetch Item
        print("in edit")
        /// sender.tag == indexPath.row
        let item = allEvents[sender.tag]
        event_id = item.id!
        if item.booking_number! == 0 {
           
            performSegue(withIdentifier: "EditEventVCID", sender: self)
        }
        print("the index is \(sender.tag)")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segue.identifier
        
        if id == "EditEventVCID"{
            let des = segue.destination as! EditEventVC
            des.event_id = event_id!
        }
    }
    @objc func removeTaped(sender: UIButton) {
        // Fetch Item
        print("in remove")
        /// sender.tag == indexPath.row
        let item = allEvents[sender.tag]
         event_id = item.id!
        print("the event id in my events \(event_id)")
        if item.booking_number == 0{
        // api code for remove
            SVProgressHUD.show()
            API().deletevent(event_id: event_id!) { (success:Bool, error:String) in
                SVProgressHUD.dismiss()
                if success{
                    SVProgressHUD.showSuccess(withStatus: error)
                    SVProgressHUD.dismiss(withDelay: 2)
                    print("deleted success")
                   self.viewWillAppear(true)
                   //deleting row from tableView
                    
//                    self.allEvents.remove(at: sender.tag)
//                    self.total -= 1
//                    let indexPath = IndexPath(item: sender.tag, section: 0)
//                    self.eventsTable.deleteRows(at: [indexPath], with: .fade)
                }else{
                    SVProgressHUD.showError(withStatus: error)
                    SVProgressHUD.dismiss(withDelay: 2)
                }
            }
        }else{
            SVProgressHUD.showError(withStatus: "have_booking".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }
        print("the index is \(sender.tag)")
        
    }
   
    func getEvents(){
        
        API().getMyEvents(page:page,user_id:user_id) { (success:Bool, result:[MyEventsModel]?) in
            SVProgressHUD.dismiss()

            if success{
                print("the result of all events is \(result?.count)")
                if result != nil {
                    self.total = UserDefaults.standard.integer(forKey: "total")
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
  

}
//func open(scheme: String) {
//    if let url = URL(string: scheme) {
//        if #available(iOS 10, *) {
//            UIApplication.shared.open(url, options: [:],
//                                      completionHandler: {
//                                        (success) in
//                                        print("Open \(scheme): \(success)")
//            })
//        } else {
//            let success = UIApplication.shared.openURL(url)
//            print("Open \(scheme): \(success)")
//        }
//    }
//}
//
//// Typical usage
//open(scheme: "tweetbot://timeline")
