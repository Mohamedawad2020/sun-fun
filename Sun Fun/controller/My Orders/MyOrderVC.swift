//
//  MyOrderVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 8/3/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import SVProgressHUD
import Kingfisher
class MyOrderVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
  
    let user_id = UserDefaults.standard.integer(forKey: "id")
    let dateFormatter = DateFormatter()
    var date = Date()
    @IBOutlet weak var ordersTable: UITableView!
    @IBOutlet weak var orderStatus: UISegmentedControl!
    
    var allOrders = [MyOrderModel.Booking]()
    var sendData:MyOrderModel.Booking?
    
    var index  = 0
    
    var backgroundView: UIView?
    

    override func viewWillAppear(_ animated: Bool) {
        allOrders.removeAll()
        getMyOrder(URl: getCurrentOrderUrl)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        
        
        ordersTable.register(nib, forCellReuseIdentifier: "TableViewCell")
        
        ordersTable.delegate = self
        ordersTable.dataSource = self
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if allOrders.count > 0
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
        return 185.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell",for: indexPath) as! TableViewCell
        let pos = indexPath.row
        if allOrders.count > 0 {
            let item = allOrders[pos]
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy h:mm a"
            date = Date(timeIntervalSince1970: TimeInterval(item.date!))
            
            cell.date.text = "\(dateFormatter.string(from: date))"
            
            cell.ticketNumberLB.text = "#\(item.booking_code!.replacingOccurrences(of: "-", with: ""))"
            
            cell.priceLB.text = "\(item.total_booking_price!) \("SR".localized())"
            
            if item.status == 1{
                cell.orderStatus.text = "completed".localized()
            }else if item.status == 2{
                cell.orderStatus.text = "refused".localized()

            }else if item.status == 3{
                cell.orderStatus.text = "finished".localized()
            }
            if item.event_image != nil{
                cell.imageOrder.kf.setImage(with: URL(string:uploadEventImageURL + item.event_image!),options: [
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage
                    ])
                cell.imageOrder.contentMode = .scaleToFill
            }
            
            cell.viewButton.addTarget(self, action: #selector(orderTaped(sender:)), for: .touchUpInside)
            cell.viewButton.tag = pos
        }

        return cell
    }
    
    @objc func orderTaped(sender: UIButton) {
        print("the tag is \(sender.tag)")
        index = sender.tag
        sendData = allOrders[index]
        performSegue(withIdentifier: "myorderID", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segue.identifier
        if id == "myorderID"{
            let des = segue.destination as! MyOrderDetailsVC
            des.orderDetails = allOrders[index]
    
        }
    }
    func getMyOrder(URl:String){
        SVProgressHUD.show()
        MyOrder_API().getMyOrders(url:URl,user_id: user_id) { (success:Bool,result:[MyOrderModel.Booking]?) in
            
            if success{
                SVProgressHUD.dismiss()
                if result != nil{
                    self.allOrders.append(contentsOf: result!)
                    self.ordersTable.reloadData()
                    print("success to get my orders")
                    
                }else{
                    print("You Have no order.")
                }
             
            }else{
                SVProgressHUD.dismiss()
                print("fail to get my orders")

            }
        }
    }
   
    @IBAction func switchTableView(_ sender: UISegmentedControl) {
        let pos = sender.selectedSegmentIndex
        if pos == 0 {
            allOrders.removeAll()
            getMyOrder(URl: getCurrentOrderUrl)
            ordersTable.reloadData()
            print("in current")
        }else if pos == 1 {
            allOrders.removeAll()
            getMyOrder(URl: getPreviousOrderUrl)
            ordersTable.reloadData()
            print("in previous order")
        }
    }
    

}
