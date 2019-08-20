//
//  NotificationDetailsVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/30/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SVProgressHUD
import SwiftyJSON
class NotificationDetailsVC: UIViewController ,GMSMapViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource{

    var eventDetails:EventSDetails!
    var eventActivities = [JSON]()
    
    
    // to send booking Activity
    var iD:Int?
    var companyID:Int?
    var userID:Int?
    var event_id :Int?
    
    var status:Int?
    var notification_id:Int?

    // var subscribers_num:Int?
    var paid_type:Int?
    var is_booking:Int?
    
    
    
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var refuseBTN: UIButton!
    @IBOutlet weak var approveBTN: UIButton!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ticketsTF: UITextView!
    @IBOutlet weak var detailsEventTF: UITextView!
    @IBOutlet weak var timeT: UILabel!
    @IBOutlet weak var timeF: UILabel!
    @IBOutlet weak var dateT: UILabel!
    @IBOutlet weak var dateF: UILabel!
    
    @IBOutlet weak var eventImage: UIImageView!
    
    
    let dateFormatter = DateFormatter()
    var date:Date?
    
    let user_id = UserDefaults.standard.integer(forKey: "id")
    let isArabic = UserDefaults.standard.bool(forKey: "is_arabic")
    
    var activityresult = [Activities]()
    
    override func viewWillAppear(_ animated: Bool) {
        ticketsTF.isEditable = false
        detailsEventTF.isEditable = false
        viewMap.isUserInteractionEnabled = false
        checkStatus()
        if CheckInternet.Connection(){
            print("in notification")
        getEventDetails()
        settings()
        }else{
            SVProgressHUD.showInfo(withStatus: "no_internet_connection".localized())
            SVProgressHUD.dismiss(withDelay: 3)
        }
        //showMap()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.layer.borderWidth = 1.0
        collectionView.layer.borderColor = UIColor.darkGray.cgColor
        collectionView.layer.cornerRadius = 5.0
        collectionView.clipsToBounds = true
        
        let nib = UINib(nibName: "ActivityCell", bundle: nil)
        
        
        collectionView.register(nib, forCellWithReuseIdentifier: "ActivityCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventActivities.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
        let pos = indexPath.row
        
        
        let item = activityresult[pos]
        
        if item.image != nil{
            cell.activityImage.kf.setImage(with: URL(string:uploadEventImageURL + item.image!),options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
                ])
            cell.activityImage.contentMode = .scaleToFill
        }
        cell.price.text = "\(item.price!) \("SR".localized())"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pos = indexPath.row
        if eventDetails.is_booking == 1{
            activityAlert()
        }else{
            SVProgressHUD.showInfo(withStatus: "bookEventFirst".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }
        
        
    }
    func activityAlert(){
        let alert = UIAlertController(title: "warning".localized(), message: "alertmessageActivity".localized(), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: { action in
            self.performSegue(withIdentifier: "ReverseActivityID", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel, handler: nil))
        self.present(alert,animated: true)
        
    }
    
    
    func showDetails(){
        if eventDetails?.image1 != nil{
            eventImage.kf.setImage(with: URL(string:uploadEventImageURL + eventDetails.image1!),options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
                ])
            eventImage.contentMode = .scaleToFill
        } else if eventDetails.image2 != nil {
            eventImage.kf.setImage(with: URL(string:uploadEventImageURL + eventDetails.image2!),options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
                ])
            eventImage.contentMode = .scaleToFill
        }
        dateFormatter.dateFormat = "MMM d, yyyy"
        date = Date(timeIntervalSince1970: TimeInterval(eventDetails.start_at!))
        dateF.text = "\(dateFormatter.string(from: date!))"
        
        dateFormatter.dateFormat = "MMM d, yyyy"
        date = Date(timeIntervalSince1970: TimeInterval(eventDetails.end_at!))
        dateT.text = "\(dateFormatter.string(from: date!))"
        
        dateFormatter.dateFormat = "h:mm a"
        date = Date(timeIntervalSince1970: TimeInterval(eventDetails.from_time!))
        timeF.text = "\(dateFormatter.string(from: date!))"
        
        dateFormatter.dateFormat = "h:mm a"
        date = Date(timeIntervalSince1970: TimeInterval(eventDetails.to_time!))
        timeT.text = "\(dateFormatter.string(from: date!))"
        
        if isArabic{
            detailsEventTF.text = eventDetails.ar_description
            ticketsTF.text = eventDetails.ar_information
        }else{
            detailsEventTF.text = eventDetails.en_description
            ticketsTF.text = eventDetails.en_information
        }
        event_id = eventDetails.id!
        is_booking = eventDetails.is_booking!
        let lat = eventDetails.latitude!
        let lon = eventDetails.longitude!
        showMap(lat: lat, lon: lon)
        
    }
    
    
    func showMap(lat:Double,lon:Double){
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 15.0)
        viewMap.camera = camera
        viewMap.delegate = self
        
        // Add a Custom marker
        let markerSquirt = GMSMarker()
        markerSquirt.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        markerSquirt.title = "Saudi"
        markerSquirt.snippet = "Saudi"
        markerSquirt.map = viewMap
        markerSquirt.icon = UIImage(named: "26")
    }
    func getEventDetails(){
        SVProgressHUD.show()
        API().getNotificationCellDetails(event_id: event_id!, user_id: user_id) { (success: Bool, result:EventSDetails?) in
            SVProgressHUD.dismiss()
            if success{
                print("notification accessed")
                self.eventDetails = result!
                if self.eventDetails != nil{
                self.eventActivities = self.eventDetails.activities
                self.showDetails()
                if self.eventActivities.count > 0 {
                    self.getEventActivities()
                }
            }
            }else{
                print("notifiaction not accessed")
            }
        }
        
        
    }
    func getEventActivities(){
        let json = eventActivities
        for data in json{
            if let data = data.dictionary ,let subCategoryData = Activities.init(dict: data) {
                self.activityresult.append(subCategoryData)
                collectionView.reloadData()
            }
            
        }
    }
    func settings(){
        refuseBTN.RoundCorners(cornerRadius: 5.0)
        approveBTN.RoundCorners(cornerRadius: 5.0)
        replyImage.roundCorners(cornerRadius: 3.0)
        
    }
    func checkStatus(){
        if status == 0 {
            viewStatus.isHidden = true
        }else if status == 1{
            buttonView.isHidden = true
            message.text = "you_have_accept_before".localized()
            replyImage.image = UIImage(named: "true")
        }else if status == 2{
            buttonView.isHidden = true
            message.text = "you_have_refused_before".localized()
            replyImage.image = UIImage(named: "false")

        }
    }
    
    @IBAction func approve(_ sender: Any) {
        refuseBTN.isEnabled = false
        self.approveBTN.isEnabled = false
        SVProgressHUD.show()
        Booking_API().accept_Refuse_Booking(url: accpeptBookingURl, booking_id: iD!, company_id: companyID!, notification_id: notification_id!, event_id: event_id!) { (success:Bool, error:String) in
            SVProgressHUD.dismiss()
            if success{
                print("booking accepted")
                
                
self.alertSendData(message: "booking_accepted".localized(), title: "alarm".localized())
            }else{
                print("booking accpet error")

                SVProgressHUD.showSuccess(withStatus: "booking_Error".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }
        }
    }
    
    @IBAction func refuse(_ sender: Any) {
        approveBTN.isEnabled = false
        self.refuseBTN.isEnabled = false
        SVProgressHUD.show()
        Booking_API().accept_Refuse_Booking(url: refuseBookingURL, booking_id: iD!, company_id: companyID!, notification_id: notification_id!, event_id: event_id!) { (success:Bool, error:String) in
            SVProgressHUD.dismiss()
            if success{
                print("booking refused")

                self.alertSendData(message: "booking_Notaccepted".localized(), title: "alarm".localized())
            }else{
                print("booking refused error")

                SVProgressHUD.showSuccess(withStatus: "booking_Error".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }
        }
    }
    func alertSendData(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ok".localized(), style: .default, handler: { action in
            _ = self.navigationController?.popViewController(animated: true)
        })
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
