//
//  MyAccountVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/27/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import SVProgressHUD
class MyAccountVC: UIViewController {

    @IBOutlet weak var upgradeToCompany: UIView!
    @IBOutlet weak var phoneNumberLB: UILabel!
    @IBOutlet weak var userNameLB: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLB: UILabel!
    
    
    
    var is_login = UserDefaults.standard.bool(forKey: "is_login")
    var image = UserDefaults.standard.string(forKey: "image")
    var name = UserDefaults.standard.string(forKey: "name")
    var phone = UserDefaults.standard.string(forKey: "phone")
    var email = UserDefaults.standard.string(forKey: "email")
    let user_type = UserDefaults.standard.integer(forKey: "user_type")

    override func viewWillAppear(_ animated: Bool) {
      profileImage.circleImage()
        if is_login{
        if image != nil{
            print("image Will be uploaded ")
            profileImage.kf.setImage(with: URL(string:uploadUserImagesURL + image!),options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
                ])
            profileImage.contentMode = .scaleToFill
            print("image uploaded success ")

        }else{
            print("the description to image is \(image?.description)")
            }
            
            userNameLB.text = name!
            emailLB.text = email!
            phoneNumberLB.text = phone!
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let tap2 = UITapGestureRecognizer(target: self, action:  #selector(personalPhotoPicker2(sender: )))
        upgradeToCompany.addGestureRecognizer(tap2)
        upgradeToCompany.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
        }
       @objc func personalPhotoPicker2(sender : UITapGestureRecognizer) {
        if user_type == 1{
        performSegue(withIdentifier: "upgradeID", sender: self)
        }
        }
    
    @IBAction func instgram(_ sender: Any) {
        API().getSocial(index: 5) { (success:Bool, result:String) in
            if success{
                self.open(scheme:result)
                
            }else{
                SVProgressHUD.showError(withStatus: "error_loading".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }
        }
    }
    @IBAction func youtube(_ sender: Any) {
        API().getSocial(index: 4) { (success:Bool, result:String) in
            if success{
                self.open(scheme:result)
                
            }else{
                
                SVProgressHUD.showError(withStatus: "error_loading".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }
        }
    }
    @IBAction func pinterest(_ sender: Any) {
        API().getSocial(index: 3) { (success:Bool, result:String) in
            if success{
                self.open(scheme:result)
                
            }else{
                SVProgressHUD.showError(withStatus: "error_loading".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }
        }
    }
    @IBAction func twitter(_ sender: Any) {
        API().getSocial(index: 2) { (success:Bool, result:String) in
            if success{
                self.open(scheme:result)
                
            }else{
                SVProgressHUD.showError(withStatus: "error_loading".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }
        }
    }
    @IBAction func facebook(_ sender: Any) {
        API().getSocial(index: 1) { (success:Bool, result:String) in
            if success{
                self.open(scheme:result)
            }else{
                SVProgressHUD.showError(withStatus: "error_loading".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }
        }
    }
    
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    
    

}
