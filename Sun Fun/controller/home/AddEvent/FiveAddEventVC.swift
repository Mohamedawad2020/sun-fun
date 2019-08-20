//
//  FiveAddEventVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/22/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import SVProgressHUD

class FiveAddEventVC: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    /// to send
    
    
    
    
    
    
    
    var dateFrome:Int?
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var submitBTN: UIButton!
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var activityAddress: UITextField!
    @IBOutlet weak var activityEnglishAddress: UITextField!
    @IBOutlet weak var maxTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var unitTF: UITextField!
    @IBOutlet weak var activityName: UITextField!

    @IBOutlet weak var activitEnglishName: UITextField!
    @IBOutlet weak var noBTN: UIButton!
    @IBOutlet weak var yesBTN: UIButton!
    
    
    
    
    let dateFormatter = DateFormatter()
    let toolbar = UIToolbar()
    

    var sendTime:Int?
    var sendDate:Int?
    
    var event_id:Int?
    let imagePicker = UIImagePickerController()
    var selectedImage: Data?
    var selectedImage1: Data?
    
    
    var flag = false
    override func viewWillAppear(_ animated: Bool) {
        activityImage.roundCorners(cornerRadius: 5.0)
        yesBTN.roundCorners(cornerRadius: 5.0)
        noBTN.roundCorners(cornerRadius: 5.0)
        submitBTN.roundCorners(cornerRadius: 5.0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.isHidden = true

        imagePicker.delegate = self
        let tap1 = UITapGestureRecognizer(target: self, action:  #selector(personalPhotoPicker1(sender: )))
        activityImage.addGestureRecognizer(tap1)
        activityImage.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
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
        self.activityImage.image = image
        self.activityImage.contentMode = .scaleToFill
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func yes(_ sender: Any) {
        homeView.isHidden = false
        flag = true
        yesBTN.setImage(UIImage(named: "true"), for: UIControl.State.normal)
        noBTN.setImage(UIImage(named: ""), for: UIControl.State.normal)
        
    }
    @IBAction func no(_ sender: Any) {
       
        homeView.isHidden = true
        flag = false
        noBTN.setImage(UIImage(named: "false"), for: UIControl.State.normal)
        yesBTN.setImage(UIImage(named: ""), for: UIControl.State.normal)
    }
   
    @IBAction func timeBTN(_ sender: UITextField) {
    let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date

        dateFormatter.dateFormat = "MMM d, yyyy"
        datePickerView.minimumDate = Date(timeIntervalSince1970: TimeInterval(dateFrome!))
        timeTF.inputView = datePickerView
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneclicked))
        toolbar.setItems([doneButton], animated: true)
        timeTF.inputAccessoryView = toolbar
        
        datePickerView.addTarget(self, action: #selector(self.timePickerFromValueChanged), for: UIControl.Event.valueChanged)
        
    }
        @objc func doneclicked(){
            self.view.endEditing(true)
        }
    
        @objc func timePickerFromValueChanged(sender:UIDatePicker) {
            dateFormatter.dateFormat = "MMM d, yyyy"
            timeTF.text = dateFormatter.string(from: sender.date)
            sendTime = Int(sender.date.timeIntervalSince1970)
        }
    
    
 
    @IBAction func dateBTN(_ sender: UITextField) {
        if !timeTF.text!.isEmpty{
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        dateFormatter.dateFormat = "MMM d, yyyy"
        datePickerView.minimumDate = dateFormatter.date(from: timeTF.text!)!
        dateTF.inputView = datePickerView
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneclicked))
        toolbar.setItems([doneButton], animated: true)
        dateTF.inputAccessoryView = toolbar
        datePickerView.addTarget(self, action: #selector(self.datePicked), for: UIControl.Event.valueChanged)
        }else{
            self.showAlert(message: "EnterStartTimeFirst".localized(), title: "alarm".localized())

        }
    }
    @objc func datePicked(sender:UIDatePicker) {
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateTF.text = dateFormatter.string(from: sender.date)
        sendDate = Int(sender.date.timeIntervalSince1970)
    }
    
    
    
    
    @IBAction func submit(_ sender: Any) {
            let title = activityName.text!
            let titleEnglish = activitEnglishName.text!
            let unit = unitTF.text!
            let price = priceTF.text!.englishNumbers()!
            let address = activityAddress.text!
            let addressEnglish = activityEnglishAddress.text!
            let max = maxTF.text!.englishNumbers()!
            let time = timeTF.text!
            let date = dateTF.text!
            
            if title.isEmpty && titleEnglish.isEmpty && unit.isEmpty && price.isEmpty && address.isEmpty && addressEnglish.isEmpty && max.isEmpty && time.isEmpty && date.isEmpty {
                SVProgressHUD.showInfo(withStatus: "all_fields_required".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }else if title.isEmpty{
                SVProgressHUD.showInfo(withStatus: "title_required".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }else if titleEnglish.isEmpty{
                SVProgressHUD.showInfo(withStatus: "titleEnglish_required".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }else if unit.isEmpty{
                SVProgressHUD.showInfo(withStatus: "unit_required".localized())
                SVProgressHUD.dismiss(withDelay: 2)
                
            }else if price.isEmpty{
                SVProgressHUD.showInfo(withStatus: "price_required".localized())
                SVProgressHUD.dismiss(withDelay: 2)
                
            }else if address.isEmpty{
                SVProgressHUD.showInfo(withStatus: "address_required".localized())
                SVProgressHUD.dismiss(withDelay: 2)
                
            }else if addressEnglish.isEmpty{
                SVProgressHUD.showInfo(withStatus: "addressEnglish_required".localized())
                SVProgressHUD.dismiss(withDelay: 2)
                
            }else if max.isEmpty{
                SVProgressHUD.showInfo(withStatus: "max_required".localized())
                SVProgressHUD.dismiss(withDelay: 2)
                
            }else if time.isEmpty{
                SVProgressHUD.showInfo(withStatus: "time_required".localized())
                SVProgressHUD.dismiss(withDelay: 2)
                
            }else if selectedImage1 == nil{
                SVProgressHUD.showInfo(withStatus: "image_required".localized())
                SVProgressHUD.dismiss(withDelay: 2)
                
            }else if date.isEmpty{
                SVProgressHUD.showInfo(withStatus: "date_required".localized())
                SVProgressHUD.dismiss(withDelay: 2)
                
            }else{
                self.submitBTN.isEnabled = false
                /// api code
                SVProgressHUD.show()
                AddEvent_API().addActivity(event_id: event_id!, start_at: sendTime!, end_at: sendDate!, image: selectedImage1!, unit: unit, price: price, max_number: max, ar_title: title, en_title: titleEnglish, ar_place: address, en_place: addressEnglish) { (success: Bool) in
                    SVProgressHUD.dismiss()
                    if success{
                        print("activity Added")
                        self.alertSendData(message: "ActivityAdedSuccess".localized(), title: "alarm".localized())
                    
                    }else{
                        print("activity Not Added")
                        SVProgressHUD.showInfo(withStatus: "activity_not_added".localized())
                        SVProgressHUD.dismiss(withDelay: 2)
                    }
                }
                
                
            }
        
        
    }
  
    
    func alertSendData(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "finish".localized(), style: .default, handler: { action in
            let vc = UIStoryboard(name: "Main", bundle: nil)
            let rootVc = vc.instantiateViewController(withIdentifier: "homeID")
            self.present(rootVc,animated: true,completion: nil)        })
        let AnotherAction = UIAlertAction(title: "AddAnotherActivity".localized(), style: .default, handler: { action in
            self.activityName.text = ""
            self.activitEnglishName.text = ""

            self.unitTF.text = ""
            self.priceTF.text = ""
            self.activityAddress.text = ""
            self.activityEnglishAddress.text = ""

            self.maxTF.text = ""
            self.timeTF.text = ""
            self.dateTF.text = ""
            self.selectedImage1 = nil
            self.activityImage.image = UIImage(named: "upload")
            self.submitBTN.isEnabled = true
        })
       
        alertController.addAction(AnotherAction)
        alertController.addAction(OKAction)

        self.present(alertController, animated: true, completion: nil)
    }

}

