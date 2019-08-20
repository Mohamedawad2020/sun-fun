//
//  BookingEventWithDetailsVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/23/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import Alamofire
import GoogleMaps
import GooglePlaces
class BookingEventWithDetailsVC: UIViewController ,GMSMapViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource{
  
    
    var eventDetails:EventSDetails!
    var eventActivities = [JSON]()
    
    
    // to send booking Activity
    var booking_id: Int?
    var activity_id:Int?
    var event_id :Int?
    var company_id:Int?
   // var subscribers_num:Int?
    var paid_type:Int?
    var is_booking:Int?
    
    var sendData = [Int:String]()

 
    @IBOutlet weak var bookbtn: UIButton!
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
        timeT.adjustsFontForContentSizeCategory = true
        timeF.adjustsFontForContentSizeCategory = true
        dateT.adjustsFontForContentSizeCategory = true
        dateF.adjustsFontForContentSizeCategory = true
        
        sendData.removeAll()
        address.adjustsFontForContentSizeCategory = true
        viewMap.isUserInteractionEnabled = false
        bookbtn.roundCorners(cornerRadius: 5.0)
        collectionView.layer.borderWidth = 1.0
        collectionView.layer.borderColor = UIColor.gray.cgColor
        collectionView.layer.cornerRadius = 5.0
        collectionView.clipsToBounds = true
        
        ticketsTF.isEditable = false
        detailsEventTF.isEditable = false
        showDetails()
        //showMap()
        if eventDetails.company_id! == user_id {
            bookbtn.isHidden = true
        }
        eventActivities = eventDetails.activities
        
       getEventActivities()
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
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
        if isArabic{
            sendData[activityresult[pos].id!] = activityresult[pos].ar_title!
        }else{
        sendData[activityresult[pos].id!] = activityresult[pos].en_title!
        }
        if item.image != nil{
                cell.activityImage.kf.setImage(with: URL(string:uploadEventImageURL + item.image!),options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
                ])
            cell.activityImage.contentMode = .scaleToFill
        }
        cell.price.text = "\(item.price!) \("SR".localized())"
        activity_id = item.id!
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pos = indexPath.row
       
        
        
        
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
        company_id = eventDetails.company_id!
        is_booking = eventDetails.is_booking!
        let lat = eventDetails.latitude!
        let lon = eventDetails.longitude!
        address.text = eventDetails.address!
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
    
    @IBAction func bookNowBTN(_ sender: Any) {
        performSegue(withIdentifier: "EventBookingID", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segue.identifier
        
        if id == "EventBookingID"{
            let des = segue.destination as! BookingEventVC
            des.receviedData = sendData
            des.event_id = event_id!
            des.company_id = company_id!
            print("send data \(sendData.description)")
        }
    }
    
    

}
