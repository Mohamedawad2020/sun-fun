//
//  UpgradeToCompanyVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/27/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import GoogleMaps
import SVProgressHUD
class UpgradeToCompanyVC: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,GMSMapViewDelegate{

    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var upgrade: UIButton!
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var national_id: UIImageView!
    @IBOutlet weak var responsibleTF: UITextField!
    
    
    let id = UserDefaults.standard.integer(forKey: "id")
    
    
    let imagePicker = UIImagePickerController()
    var selectedImage: Data?
    
    var selectedImage1: Data?
    var lat:Double?
    var lon:Double?
    override func viewWillAppear(_ animated: Bool) {
        addressTF.isUserInteractionEnabled = false
        initialLocation()
        national_id.roundCorners(cornerRadius: 10.0)
        upgrade.roundCorners(cornerRadius: 5.0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        let tap1 = UITapGestureRecognizer(target: self, action:  #selector(personalPhotoPicker1(sender: )))
        national_id.addGestureRecognizer(tap1)
        national_id.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        viewMap.clear()
        self.lat = coordinate.latitude
        self.lon = coordinate.longitude
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
           // self.address = lines.joined(separator: "\n")
            // 4
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func personalPhotoPicker1(sender : UITapGestureRecognizer) {
        print("Image Tapped")
        makeActionAlert()
        //itemImage = 1
        
    }
    func makeActionAlert(){
        let alert = UIAlertController(title: "", message: "Upload_Image".localized(), preferredStyle: .actionSheet)
        let takePhoto = UIAlertAction(title: "take_photo".localized(), style: .default) { (action) in
            
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }
        let openCamer = UIAlertAction(title: "open_Camer".localized(), style: .default) { (action) in
            
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true)
            
        }
        let cancel = UIAlertAction(title: "Cancel".localized(), style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(takePhoto)
        alert.addAction(openCamer)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var image: UIImage?
        
        // extract image from the picker and save it
        if let editedImage = info[.editedImage] as? UIImage {
            
            self.selectedImage = editedImage.jpegData(compressionQuality: 0.7)!
            //            self.modelFourImage.image = editedImage
            image = editedImage
        }else if let originalImage = info[.originalImage] as? UIImage {
            self.selectedImage = originalImage.jpegData(compressionQuality: 0.7)!
            //self.modelFourImage.image = originalImage
            image = originalImage
        }
        
        self.selectedImage1 = selectedImage
        self.national_id.image = image
        self.national_id.contentMode = .scaleToFill
        
        self.dismiss(animated: true, completion: nil)
    }
    func initialLocation(){
        let camera = GMSCameraPosition.camera(withLatitude: 24.694970, longitude: 46.724130, zoom: 15.0)
        viewMap.camera = camera
        viewMap.delegate = self
        
        // Add a Custom marker
        let markerSquirt = GMSMarker()
        markerSquirt.position = CLLocationCoordinate2D(latitude: 24.694970, longitude: 46.724130)
        markerSquirt.title = "Saudi"
        markerSquirt.snippet = "Saudi"
        markerSquirt.map = viewMap
        markerSquirt.icon = UIImage(named: "26")
    }

    @IBAction func upgradeBTN(_ sender: Any) {
        upgrade.isEnabled = false
        let resp = responsibleTF.text!
        let address = addressTF.text!
        if resp.isEmpty && address.isEmpty {
            SVProgressHUD.showInfo(withStatus: "all_fields_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if resp.isEmpty{
            SVProgressHUD.showInfo(withStatus: "responsible_Required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if address.isEmpty{
            SVProgressHUD.showInfo(withStatus: "address_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)

        }else{
            
            SVProgressHUD.show()
            Edit_API().upgradeToCompany(id: id, national_image: selectedImage1!, address: address, responsible: resp, latitude: lat!, longitude: lon!) { (success:Bool) in
                SVProgressHUD.dismiss()
                if success{
                    print("Upgraded")
                    self.alertSendData(message: "upgradeSuccess".localized(), title: "alarm".localized())

//
                    
                }else{
                    print("not Upgraded")
                    self.alertSendData(message: "FailedUpgradedToCompany".localized(), title: "alarm".localized())

                }
            }
        }
        
        
    }
    func alertSendData(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ok".localized(), style: .default, handler: { action in
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

}
//companyprofileIDUpgrade
