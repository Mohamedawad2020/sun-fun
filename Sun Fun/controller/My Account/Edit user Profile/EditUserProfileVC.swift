//
//  EditUserProfileVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/27/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import GoogleMaps
import SVProgressHUD
class EditUserProfileVC: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    
    @IBOutlet weak var saveBTN: UIButton!
   
    @IBOutlet weak var updatePassword: UIButton!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    let id = UserDefaults.standard.integer(forKey: "id")
    
    
    let imagePicker = UIImagePickerController()
    var selectedImage: Data?
    
    var selectedImage1: Data?
    var newPassword:String?
    
    
    
    var name = UserDefaults.standard.string(forKey: "name")
    var phone = UserDefaults.standard.string(forKey: "phone")
    var email = UserDefaults.standard.string(forKey: "email")
    var imageProfile = UserDefaults.standard.string(forKey: "image")

    override func viewWillAppear(_ animated: Bool) {
     
        
        profileImage.circleImage()
        
       
        imagedelegate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialData()
        imagePicker.delegate = self
       
        // Do any additional setup after loading the view.
    }
    func initialData(){
        saveBTN.roundCorners(cornerRadius: 5.0)
        updatePassword.roundCorners(cornerRadius: 5.0)

        userName.text = name!
        emailTF.text = email!
        phoneTF.text = phone!
        
        if imageProfile != nil{
            print("image Will be uploaded ")
            profileImage.kf.setImage(with: URL(string:uploadUserImagesURL + imageProfile!),options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
                ])
            profileImage.contentMode = .scaleToFill
            print("image uploaded success ")
            
        }
    }
    func imagedelegate(){
        let tap1 = UITapGestureRecognizer(target: self, action:  #selector(personalPhotoPicker1(sender: )))
        profileImage.addGestureRecognizer(tap1)
        profileImage.isUserInteractionEnabled = true
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
            self.profileImage.image = image
            self.profileImage.contentMode = .scaleToFill
            
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func SaveChanges(_ sender: Any) {
        saveBTN.isEnabled = false
        let name = userName.text!
        let email = emailTF.text!
        let phone = Int(phoneTF.text!)!
        
        if selectedImage1 != nil{
            Edit_API().update_user_image(id: id, image: selectedImage1!) { (success: Bool) in
                
                if success{
                    
                    print("image uploaded successfully !")
//                    self.alertSendData(message: "ImageUpdatedSuccess".localized(), title: "alarm".localized())
                }else{
                    print("image uploaded Failed !")
                }
            }
        }else if name.isEmpty && email.isEmpty && phoneTF.text!.isEmpty{
            SVProgressHUD.showInfo(withStatus: "all_fields_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if name.isEmpty{
            SVProgressHUD.showInfo(withStatus: "user_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if email.isEmpty{
            SVProgressHUD.showInfo(withStatus: "email_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if !Validaton.isValidEmailAddress(emailAddressString: email){
            SVProgressHUD.showInfo(withStatus: "email_invalid".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if phoneTF.text!.isEmpty{
            SVProgressHUD.showInfo(withStatus: "phone_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if phoneTF.text!.count < 10 {
            SVProgressHUD.showInfo(withStatus: "phone_invalid".localized())
            SVProgressHUD.dismiss(withDelay: 2)
            
        }else{
            // api code here
            SVProgressHUD.show()
            Edit_API().update_user_profile(id: id, name: name, email: email, phone_code: 966, phone: phone) { (success:Bool, error:String) in
                SVProgressHUD.dismiss()

                if success{
                    print("success to update profile ")
                      self.alertSendData(message: "UpdatedSuccess".localized(), title: "alarm".localized())
                    
                }else{
                    print("failed to update profile")
                }
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
    @IBAction func updatePasswordBTN(_ sender: Any) {
   
        let alert = UIAlertController(title: "alarm".localized(), message: "enterActivitySubscribers".localized(), preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "enterNumber".localized()
            textField.keyboardType = UIKeyboardType.default
            textField.isSecureTextEntry = true
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            if !textField!.text!.isEmpty{
              self.newPassword = textField!.text!
                SVProgressHUD.show()
                Edit_API().update_user_password(id: self.id, password: self.newPassword!, completion: { (success:Bool, error:String) in
                    SVProgressHUD.dismiss()
                    if success{
                        self.passwordUpdated(message: "passwordUpdated".localized(), title: "alarm".localized())
                    }else{
                        print("fail to update password")
                    }
                })
            }
          
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    
    }
    func passwordUpdated(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "finish".localized(), style: .default, handler: { action in
            _ = self.navigationController?.popViewController(animated: true)
        })
        let finishAction = UIAlertAction(title: "ok".localized(), style: .default, handler: nil)
        
        alertController.addAction(finishAction)
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
