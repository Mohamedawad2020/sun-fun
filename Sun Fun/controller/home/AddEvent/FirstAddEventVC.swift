//
//  FirstAddEventVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/22/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import iOSDropDown
import SwiftyJSON
import SVProgressHUD
class FirstAddEventVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var nextB: UIButton!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var eventOrganizerTF: UITextField!
    @IBOutlet weak var typesTF: DropDown!
    @IBOutlet weak var departments: DropDown!
    @IBOutlet weak var eventNameTF: UITextField!
    @IBOutlet weak var eventEnglishName: UITextField!
    
    var eventTypesData = [EventTypes.types]()
    var ar_title = [String]()
    var en_title = [String]()
    var event_Type_IDS = [Int]()
    var event_Type:Int?
    var flag = true
    
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
    
    var type_id:Int?
    var cat_id:Int?
    var itemImage:Int?
    let imagePicker = UIImagePickerController()
    var selectedImage: Data?
    var selectedImage1: Data?
    var selectedImage2: Data?
    override func viewWillAppear(_ animated: Bool) {
        
        imageDelegate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        load_event_types()

        round()

        imagePicker.delegate = self
       
        // Do any additional setup after loading the view.
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
    
    
    
    
    
    
    
    
    
    
    @IBAction func nextBtn(_ sender: Any) {
        let name = eventNameTF.text!
        let englishName = eventEnglishName.text!
        let dept = departments.text!
        let type = typesTF.text!
        let respo = eventOrganizerTF.text!
        
        if name.isEmpty && englishName.isEmpty && dept.isEmpty && type.isEmpty && respo.isEmpty && selectedImage1 == nil && selectedImage2 == nil {
            SVProgressHUD.showInfo(withStatus: "all_fields_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if name.isEmpty{
            SVProgressHUD.showInfo(withStatus: "eventNameRequired".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if englishName.isEmpty{
            SVProgressHUD.showInfo(withStatus: "eventEnglishNameRequired".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if dept.isEmpty{
            SVProgressHUD.showInfo(withStatus: "departmentNameRequired".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if type.isEmpty{
            SVProgressHUD.showInfo(withStatus: "typenameRequired".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if respo.isEmpty{
            SVProgressHUD.showInfo(withStatus: "responsibleRequired".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if selectedImage1 == nil {
            SVProgressHUD.showInfo(withStatus: "firstImageRequired".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if selectedImage2 == nil{
            SVProgressHUD.showInfo(withStatus: "secondImageRequired".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else{
             performSegue(withIdentifier: "ToSecond", sender: self)
            eventNameTF.text = ""
            departments.text = ""
            typesTF.text = ""
            eventOrganizerTF.text = ""
            image1.image = UIImage(named: "upload")
            image2.image = UIImage(named: "upload")

        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segue.identifier
        
        if id == "ToSecond"{
            let des = segue.destination as! SecondAddEventVC
            des.cat_id = cat_id!
            des.type_id = type_id!
            des.Image1 = selectedImage1!
            des.Image2 = selectedImage2!
            des.eventName = eventNameTF.text!
            des.eventenglishName = eventEnglishName.text!
            des.responsible = eventOrganizerTF.text!
        }
    }
    
}
