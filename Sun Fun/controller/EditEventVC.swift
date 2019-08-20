//
//  EditEventVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/31/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import iOSDropDown
import SwiftyJSON
import GoogleMaps
import GooglePlaces
import SVProgressHUD
class EditEventVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate ,CLLocationManagerDelegate,GMSMapViewDelegate {
    var event_id:Int?
    //first////////
    @IBOutlet weak var nextB: UIButton!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var typesTF: DropDown!
    @IBOutlet weak var departments: DropDown!
    @IBOutlet weak var eventNameTF: UITextField!
    
    var eventTypesData = [EventTypes.types]()
    var ar_title = [String]()
    var en_title = [String]()
    var event_Type_IDS = [Int]()
    var event_Type:Int?
    
    /// category
    var categoryData = [EventTypes.Event_sub_category]()
    var ar_title_category = [String]()
    var en_title_category = [String]()
    var category_ids = [Int]()
    let isArabic = UserDefaults.standard.bool(forKey: "is_arabic")
    let company_id = UserDefaults.standard.integer(forKey: "id")

    var eventResult = [EventTypes.Event_sub_category]()
    var categoryArray = [[JSON]]()
    var allEvents = [EventSDetails]()
    let dateFormatter = DateFormatter()
    var date:Date?
    
    var type_id:Int?
    var cat_id:Int?
    var itemImage:Int?
    let imagePicker = UIImagePickerController()
    var selectedImage: Data?
    var selectedImage1: Data?
    var selectedImage2: Data?
    // second////////////
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var viewMap: GMSMapView!
    var lat:Double?
    var lon:Double?
    // three //////////
    @IBOutlet weak var timeT: UITextField!
    @IBOutlet weak var dateT: UITextField!
    @IBOutlet weak var dateF: UITextField!
    @IBOutlet weak var timeF: UITextField!
    let toolbar = UIToolbar()
    
    
    var dateFrome:Int?
    var timeFrom:Int?
    var dateTo:Int?
    var timeTo:Int?
    //four///////////
    @IBOutlet weak var ticketsDetailsTV: UITextView!
    @IBOutlet weak var eventDetailsTV: UITextView!
    @IBOutlet weak var maxNumber: UITextField!
    @IBOutlet weak var price: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
       //first
        imageDelegate()
        // second
        initialLocation()
        nextB.roundCorners(cornerRadius: 5.0)
        

    }

    override func viewDidLoad() {
        super.viewDidLoad()
       //first
        load_event_types()
        round()
        imagePicker.delegate = self
        // second
        viewMap.delegate = self

        
    }
    func imageDelegate(){
        let tap1 = UITapGestureRecognizer(target: self, action:  #selector(personalPhotoPicker1(sender: )))
        image1.addGestureRecognizer(tap1)
        image1.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action:  #selector(personalPhotoPicker2(sender: )))
        image2.addGestureRecognizer(tap2)
        image2.isUserInteractionEnabled = true
    }
    @objc func personalPhotoPicker1(sender : UITapGestureRecognizer) {
        print("Image Tapped")
        makeActionAlert()
        itemImage = 1
        
    }
    @objc func personalPhotoPicker2(sender : UITapGestureRecognizer) {
        print("Image Tapped")
        makeActionAlert()
        itemImage = 2
        
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
        if itemImage == 1{
            
            self.selectedImage1 = selectedImage
            self.image1.image = image
            self.image1.contentMode = .scaleToFill
            
        }else if itemImage == 2{
            
            self.selectedImage2 = selectedImage
            self.image2.image = image
            self.image2.contentMode = .scaleToFill
            
        }
        self.dismiss(animated: true, completion: nil)
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
                        self.departments.optionArray = self.ar_title
                        self.event_Type_IDS.append(item.id!)
                        
                        self.departments.optionIds = self.event_Type_IDS
                        self.departments.didSelect(completion: { (selectedItem, index, id) in
                            self.departments.text = selectedItem
                            self.cat_id = id
                            // make subcaregory empty
                            self.typesTF.text = nil
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
                                
                                self.load_sub_categorys(result: self.eventResult)
                                self.eventResult.removeAll()
                            }else{
                                self.typesTF.text = nil
                                self.typesTF.optionArray = []
                                self.typesTF.optionIds = []
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
                        self.departments.optionArray = self.en_title
                        self.event_Type_IDS.append(item.id!)
                        self.departments.optionIds = self.event_Type_IDS
                        self.departments.didSelect(completion: { (selecteditem, index, id) in
                            self.departments.text = selecteditem
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
                                
                                self.load_sub_categorys(result: self.eventResult)
                                self.eventResult.removeAll()
                            }else{
                                
                                self.typesTF.text = nil
                                self.typesTF.optionArray.removeAll()
                                self.typesTF.optionIds?.removeAll()
                                self.en_title_category.removeAll()
                                
                            }
                        })
                        // id
                        
                    }
                    print("the categoy size is \(self.categoryArray.count)")
                    
                    
                }
                self.departments.showList()
                self.departments.hideList()
            }else{
                SVProgressHUD.showError(withStatus: "get_data_error".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }
        }
    }
    func load_sub_categorys(result:[EventTypes.Event_sub_category]?) {
        self.categoryData.removeAll()
        self.typesTF.text = nil
        self.ar_title_category.removeAll()
        self.category_ids.removeAll()
        self.en_title_category.removeAll()
        self.categoryData = result!
        if self.categoryData.count > 0 {
            if self.isArabic{
                
                
                for item  in self.categoryData {
                    
                    self.ar_title_category.append(item.ar_title!)
                    self.typesTF.optionArray = self.ar_title_category
                    self.category_ids.append(item.id!)
                    self.typesTF.optionIds = self.category_ids
                    self.typesTF.didSelect(completion: { (selectedItem, index, id) in
                        self.typesTF.text = selectedItem
                        
                        self.type_id = id
                        
                        print("the id for subCategory is \(id)")
                    })
                    // id
                    
                }
            }else {
                
                
                for item in self.categoryData {
                    self.en_title_category.append(item.en_title!)
                    self.typesTF.optionArray = self.en_title_category
                    self.category_ids.append(Int(item.id!))
                    self.typesTF.optionIds = self.category_ids
                    self.typesTF.didSelect(completion: { (selecteditem, index, id) in
                        self.typesTF.text = selecteditem
                        self.type_id = id
                        
                        print("the id for subCategory is \(id)")
                    })
                    // id
                    
                }
            }
            
        }else{
            
        }
        self.typesTF.showList()
        self.typesTF.hideList()
    }
    func round(){
        image1.roundCorners(cornerRadius: 10)
        image2.roundCorners(cornerRadius: 10)
        nextB.roundCorners(cornerRadius: 5.0)
    }
    
    
    
    
    
    
    
    
    
    

    //second
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
    }
    @objc func timePicked1(sender:UIDatePicker) {
        dateFormatter.dateFormat = "h:mm a"
        timeF.text = dateFormatter.string(from: sender.date)
        timeFrom = Int(sender.date.timeIntervalSince1970)
    }
    
    @IBAction func dateT_BTN(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        let currentDate = Date()
        datePickerView.minimumDate = currentDate
        dateT.inputView = datePickerView
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneclicked))
        toolbar.setItems([doneButton], animated: true)
        dateT.inputAccessoryView = toolbar
        datePickerView.addTarget(self, action: #selector(self.datePicked2), for: UIControl.Event.valueChanged)
    }
    @objc func datePicked2(sender:UIDatePicker) {
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateT.text = dateFormatter.string(from: sender.date)
        dateTo = Int(sender.date.timeIntervalSince1970)
    }
    @IBAction func timeT_BTN(_ sender: UITextField) {
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
    }
    @objc func timePicked2(sender:UIDatePicker) {
        dateFormatter.dateFormat = "h:mm a"
        timeT.text = dateFormatter.string(from: sender.date)
        timeTo = Int(sender.date.timeIntervalSince1970)
    }
    
    
  //three

    @IBAction func nextBtn(_ sender: Any) {
        let name = eventNameTF.text!
        let dept = departments.text!
        let type = typesTF.text!
        let addre = addressTF.text!
        let priceEvent = price.text!
        let max_num = maxNumber.text!
        let eventTV = eventDetailsTV.text!
        let ticketTV = ticketsDetailsTV.text!
        if name.isEmpty && dept.isEmpty && type.isEmpty && selectedImage1 == nil && selectedImage2 == nil && addre.isEmpty
            && dateF.text!.isEmpty && timeF.text!.isEmpty && dateT.text!.isEmpty && timeT.text!.isEmpty
            && priceEvent.isEmpty && max_num.isEmpty && eventTV.isEmpty && ticketTV.isEmpty{
            SVProgressHUD.showInfo(withStatus: "all_fields_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else{
           SVProgressHUD.show()
            AddEvent_API().EditEvent(id:event_id! , company_id: company_id, ar_title: name, ar_description: eventTV, start_at: dateFrome!, end_at: dateTo!, from_time: timeFrom!, to_time: timeTo!, address: addre, image1: selectedImage1!, image2: selectedImage2!, latitude: lat!, longitude: lon!, price: priceEvent, max_number: max_num, ar_information: ticketTV, cat_id: cat_id!, sub_id: type_id!) { (success:Bool) in
                SVProgressHUD.dismiss()
                if success{
                    SVProgressHUD.showInfo(withStatus: "event_edited".localized())
                    SVProgressHUD.dismiss(withDelay: 2)
                }else{
                    SVProgressHUD.showInfo(withStatus: "event_not_edited".localized())
                    SVProgressHUD.dismiss(withDelay: 2)
                }
            }
            
        }
        
    }
    

    

}
