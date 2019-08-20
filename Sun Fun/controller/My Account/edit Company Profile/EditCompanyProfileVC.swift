//
//  EditCompanyProfileVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/30/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import SVProgressHUD
class EditCompanyProfileVC: UIViewController {

    @IBOutlet weak var refusedEvents: UILabel!
    @IBOutlet weak var acceptedEvents: UILabel!
    @IBOutlet weak var creditLimit: UILabel!
    
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var emailLB: UILabel!
    @IBOutlet weak var phone_number: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var myEventView: UIView!
    
    
    var is_login = UserDefaults.standard.bool(forKey: "is_login")
    var image = UserDefaults.standard.string(forKey: "image")
    var name = UserDefaults.standard.string(forKey: "name")
    var phone = UserDefaults.standard.string(forKey: "phone")
    var email = UserDefaults.standard.string(forKey: "email")
    var address = UserDefaults.standard.string(forKey: "address")
    var ratings = UserDefaults.standard.integer(forKey: "ratings")
    let id = UserDefaults.standard.integer(forKey: "id")

    override func viewWillAppear(_ animated: Bool) {
        infoData()
        checkRate()
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
            
            companyName.text = name!
            emailLB.text = email!
            phone_number.text = phone!
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap1 = UITapGestureRecognizer(target: self, action:  #selector(view2(sender: )))
        myEventView.addGestureRecognizer(tap1)
        myEventView.isUserInteractionEnabled = true
        
    }
    @objc func view2(sender : UITapGestureRecognizer) {
        
        performSegue(withIdentifier: "CmyEventID", sender: self)
        
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
    
    // Typical usage
    func checkRate(){
        switch ratings {
        case 1:
            img1.image = UIImage(named: "13")
            img2.image = UIImage(named: "14")
            img3.image = UIImage(named: "14")
            img4.image = UIImage(named: "14")
            img5.image = UIImage(named: "14")

        case 2:
            img1.image = UIImage(named: "13")
            img2.image = UIImage(named: "13")
            img3.image = UIImage(named: "14")
            img4.image = UIImage(named: "14")
            img5.image = UIImage(named: "14")

        case 3:
            img1.image = UIImage(named: "13")
            img2.image = UIImage(named: "13")
            img3.image = UIImage(named: "13")
            img4.image = UIImage(named: "14")
            img5.image = UIImage(named: "14")

        case 4:
            img1.image = UIImage(named: "13")
            img2.image = UIImage(named: "13")
            img3.image = UIImage(named: "13")
            img4.image = UIImage(named: "13")
            img5.image = UIImage(named: "14")

        case 5:
            img1.image = UIImage(named: "13")
            img2.image = UIImage(named: "13")
            img3.image = UIImage(named: "13")
            img4.image = UIImage(named: "13")
            img5.image = UIImage(named: "13")

        default:
            img1.image = UIImage(named: "14")
            img2.image = UIImage(named: "14")
            img3.image = UIImage(named: "14")
            img4.image = UIImage(named: "14")
            img5.image = UIImage(named: "14")
            print("No Rating")
        }
    }
    func infoData(){
        API().getCompanyInfo(user_id: id) { (success:Bool, result:CompanyInfoModel?) in
            if success{
                self.creditLimit.text = "\(result!.credit_limit!)"
                self.acceptedEvents.text = "\(result!.accepted!)"
                self.refusedEvents.text = "\(result!.refused!)"
            }else{
                print("fail to get info")
            }
        }
    }

}
