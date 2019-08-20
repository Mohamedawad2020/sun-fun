//
//  MyOrderDetailsVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 8/4/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyOrderDetailsVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {
  
    
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var ticNum: UILabel!
    @IBOutlet weak var barcode: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subscriberNumber: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var ticketNumber: UILabel!
    
    
    
    
    var orderDetails:MyOrderModel.Booking?
    var orderActivities = [JSON]()
    let isArabic = UserDefaults.standard.bool(forKey: "is_arabic")

   
    var activityresult = [MyOrderModel.booking_details]()
    override func viewWillAppear(_ animated: Bool) {
        eventImage.circleImage()
        if orderDetails!.event_image != nil{
            eventImage.kf.setImage(with: URL(string:uploadEventImageURL + orderDetails!.event_image!),options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
                ])
            eventImage.contentMode = .scaleToFill
        }
        ticketNumber.text = "\(orderDetails!.booking_code!.replacingOccurrences(of: "-", with: ""))"
        price.text = "\(orderDetails!.total_booking_price!)"
        subscriberNumber.text = "\(orderDetails!.subscribers_num!)"
        if orderDetails!.booking_image != nil{
            print("image found")
            barcode.kf.setImage(with: URL(string:QRCodeImageURL +  orderDetails!.booking_image!),options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
                ])
            barcode.contentMode = .scaleToFill
        }else{
            print("image not found")
        }
        orderActivities = orderDetails!.booking_details
        print("activities size \(orderActivities.count)")
        getEventActivities()
    }
    func getEventActivities(){
        let json = orderActivities
        
        for data in json{
            if let data = data.dictionary ,let subCategoryData = MyOrderModel.booking_details.init(dict: data) {
                self.activityresult.append(subCategoryData)
                tableView.reloadData()
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "MyActivityCel", bundle: nil)
        
        
        tableView.register(nib, forCellReuseIdentifier: "MyActivityCel")
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if activityresult.count > 0
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderActivities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyActivityCel",for: indexPath) as! MyActivityCel
        let pos = indexPath.row
        if activityresult.count > 0 {
            
            let item = activityresult[pos]
            cell.activityNumber.text = "\("activity_Name_number".localized())\((pos + 1).asWord) : "
            if isArabic{
            cell.activityName.text = item.activitie_ar_title
            }else{
                cell.activityName.text = item.activitie_en_title
            }
            cell.subscribNumber.text = "\(item.subscribers_num!)"
            if item.activitie_image != nil{
                cell.activityImage.kf.setImage(with: URL(string:uploadEventImageURL + item.activitie_image!),options: [
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage
                    ])
                cell.activityImage.contentMode = .scaleToFill
            }
        }
       
        return cell
    }

}
