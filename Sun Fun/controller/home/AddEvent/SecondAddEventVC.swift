//
//  SecondAddEventVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/22/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import GooglePlaces
import SVProgressHUD
import iOSDropDown
class SecondAddEventVC: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {

    
    
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var nextBTN: UIButton!
    var lat:Double?
    var lon:Double?
    
    // send to third screen
    var Image1: Data?
    var Image2: Data?
    var responsible:String?
    var eventName:String?
    var eventenglishName:String?
    var type_id:Int?
    var cat_id:Int?
    
    let isArabic = UserDefaults.standard.bool(forKey: "is_arabic")

    override func viewWillAppear(_ animated: Bool) {
        addressTF.isEnabled = false
        nextBTN.roundCorners(cornerRadius: 5.0)
        initialLocation()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewMap.delegate = self
       
        
    }
    func initialLocation(){
        let camera = GMSCameraPosition.camera(withLatitude: 24.694970, longitude: 46.724130, zoom: 13.0)
        viewMap.camera = camera
        
        
        // Add a Custom marker
        let markerSquirt = GMSMarker()
        markerSquirt.position = CLLocationCoordinate2D(latitude: 24.694970, longitude: 46.724130)
        markerSquirt.title = "Saudi"
        markerSquirt.snippet = "Saudi"
        markerSquirt.map = viewMap
        markerSquirt.icon = UIImage(named: "26")
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        lat = coordinate.latitude
        lon = coordinate.longitude
        viewMap.clear()
        
        reverseGeocodeCoordinate(coordinate)
        
        let markerSquirt = GMSMarker()
        markerSquirt.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        markerSquirt.title = "Saudi"
        markerSquirt.snippet = "Saudi"
        markerSquirt.map = viewMap
        markerSquirt.icon = UIImage(named: "26")
    }
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            // 3
            print("the lines is \(lines.joined(separator: "\n"))")
            self.addressTF.text = lines.joined(separator: "\n")
            
            // 4
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    
    @IBAction func nextB(_ sender: Any) {
        
        let addre = addressTF.text!
        if addre.isEmpty{
            SVProgressHUD.showInfo(withStatus: "address_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else{
              performSegue(withIdentifier: "ToThird", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segue.identifier
        
        if id == "ToThird"{
            let des = segue.destination as! ThirdAddEventVC
            des.cat_id = cat_id!
            des.type_id = type_id!
            des.Image1 = Image1!
            des.Image2 = Image2!
            des.eventName = eventName!
            des.eventenglishName = eventenglishName!
            des.responsible = responsible!
            des.address = addressTF.text!
            
            des.latitude = lat!
            des.longitude = lon!
        }
    }


}
