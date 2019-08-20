//
//  MoreVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/26/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import SVProgressHUD
class MoreVC: UIViewController {

    @IBOutlet weak var language: UIView!
    @IBOutlet weak var profile: UIView!
    @IBOutlet weak var signOutView: UIView!
    @IBOutlet weak var editProfileView: UIView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var aboutAppView: UIView!
    @IBOutlet weak var termsView: UIView!
    @IBOutlet weak var bankingView: UIView!
    @IBOutlet weak var qrcodeView: UIView!
    
    
    let user_type = UserDefaults.standard.integer(forKey: "user_type")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap2 = UITapGestureRecognizer(target: self, action:  #selector(view2(sender: )))
        termsView.addGestureRecognizer(tap2)
        termsView.isUserInteractionEnabled = true
        
        let tap3 = UITapGestureRecognizer(target: self, action:  #selector(view3(sender: )))
        aboutAppView.addGestureRecognizer(tap3)
        aboutAppView.isUserInteractionEnabled = true
        
        let tap4 = UITapGestureRecognizer(target: self, action:  #selector(view4(sender: )))
        contactView.addGestureRecognizer(tap4)
        contactView.isUserInteractionEnabled = true
        
        let tap5 = UITapGestureRecognizer(target: self, action:  #selector(view5(sender: )))
        editProfileView.addGestureRecognizer(tap5)
        editProfileView.isUserInteractionEnabled = true
        
        let tap6 = UITapGestureRecognizer(target: self, action:  #selector(view6(sender: )))
        signOutView.addGestureRecognizer(tap6)
        signOutView.isUserInteractionEnabled = true
        
        let tap7 = UITapGestureRecognizer(target: self, action:  #selector(view7(sender: )))
        profile.addGestureRecognizer(tap7)
        profile.isUserInteractionEnabled = true
        
        let tap8 = UITapGestureRecognizer(target: self, action:  #selector(view8(sender: )))
        language.addGestureRecognizer(tap8)
        language.isUserInteractionEnabled = true
      
        let tap9 = UITapGestureRecognizer(target: self, action:  #selector(view9(sender: )))
        qrcodeView.addGestureRecognizer(tap9)
        qrcodeView.isUserInteractionEnabled = true
        
        let tap10 = UITapGestureRecognizer(target: self, action:  #selector(view10(sender: )))
        bankingView.addGestureRecognizer(tap10)
        bankingView.isUserInteractionEnabled = true
        
    }
    
    @objc func view2(sender : UITapGestureRecognizer) {
        if CheckInternet.Connection(){
            performSegue(withIdentifier: "termAndConditionID", sender: self)
        }else{
            SVProgressHUD.showInfo(withStatus: "no_internet_connection".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }
    }
    @objc func view3(sender : UITapGestureRecognizer) {
        if CheckInternet.Connection(){
            performSegue(withIdentifier: "AboutAppID", sender: self)
        }else{
            SVProgressHUD.showInfo(withStatus: "no_internet_connection".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }
    }
    @objc func view4(sender : UITapGestureRecognizer) {
        
        performSegue(withIdentifier: "ContactUsID", sender: self)
        
    }
    @objc func view5(sender : UITapGestureRecognizer) {
                    performSegue(withIdentifier: "edituserProfileID", sender: self)
    }
    @objc func view6(sender : UITapGestureRecognizer) {
        UserDefaults.standard.set(false,forKey: "is_login")
        
        UserDefaults.standard.removeObject(forKey: "image")
        API().logOut { (success:Bool, error:String) in
            if success{
                print("loged out")
            }else{
                print("failed to log out")
            }
        }
        let vc = UIStoryboard(name: "Main", bundle: nil)
        
        let rootVc = vc.instantiateViewController(withIdentifier: "loginvc") as! UINavigationController
        self.present(rootVc, animated: true, completion: nil)
        
        
    }
    @objc func view7(sender : UITapGestureRecognizer) {
        if CheckInternet.Connection(){
            if user_type == 1{
            performSegue(withIdentifier: "editProfileIDSegue", sender: self)
            }else if user_type == 2{
                performSegue(withIdentifier: "companyProfileID", sender: self)
            }
        }else{
            SVProgressHUD.showInfo(withStatus: "no_internet_connection".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }
    }
    @objc func view8(sender : UITapGestureRecognizer) {
        var msg = ""
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UserDefaults.standard.set(false, forKey: "is_arabic")
            msg = "please restart application to update language"
        } else {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UserDefaults.standard.set(true, forKey: "is_arabic")
            msg = "من فضلك قم بإعادة تشغيل التطبيق لتحديث لغة التطبيق"
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeID")
        let appDlg = UIApplication.shared.delegate as? AppDelegate
        appDlg?.window?.rootViewController = vc
        
        self.showAlert(message: msg)
        
    }
    @objc func view9(sender : UITapGestureRecognizer) {
        if user_type == 2{
        performSegue(withIdentifier: "qrcodeID", sender: self)
        }else{
            self.showAlert(message: "not_allowed".localized(), title: "Warning".localized())
        }
    }

    @objc func view10(sender : UITapGestureRecognizer) {
        
            performSegue(withIdentifier: "bankID", sender: self)
       
    }

}

