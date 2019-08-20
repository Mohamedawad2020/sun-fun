//
//  LoginVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/16/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import SVProgressHUD
class LoginVC: UIViewController {

    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    let user_type = UserDefaults.standard.integer(forKey: "user_type")
    let isArabic = UserDefaults.standard.bool(forKey: "is_arabic")

     var is_login = UserDefaults.standard.bool(forKey: "is_login")
    override func viewDidAppear(_ animated: Bool) {
        login.roundCorners(cornerRadius: 20.0)
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    
//    func changeLanguage(sender:UITapGestureRecognizer) {
//        var msg = ""
//        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
//            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
//            UIView.appearance().semanticContentAttribute = .forceLeftToRight
//            UserDefaults.standard.set(false, forKey: "is_arabic")
//           // msg = "please restart application to update language"
//        } else {
//            LocalizationSystem.sharedInstance.setLanguage(languageCode: "ar")
//            UIView.appearance().semanticContentAttribute = .forceRightToLeft
//            UserDefaults.standard.set(true, forKey: "is_arabic")
//          //  msg = "من فضلك قم بإعادة تشغيل التطبيق لتحديث لغة التطبيق"
//        }
//
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginvc") as! LoginVC
//        let appDlg = UIApplication.shared.delegate as? AppDelegate
//        appDlg?.window?.rootViewController = vc
//
//        self.showAlert(message: msg)
//    }
    
    @IBAction func loginBtn(_ sender: Any) {
        if CheckInternet.Connection(){
        let email = emailTF.text!
        let password = passwordTF.text!
        if email.isEmpty && password.isEmpty{
            SVProgressHUD.showInfo(withStatus: "all_fields_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if email.isEmpty {
            SVProgressHUD.showInfo(withStatus: "email_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        } else if password.isEmpty {
            SVProgressHUD.showInfo(withStatus: "password_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if !Validaton.isValidEmailAddress(emailAddressString: email){
            SVProgressHUD.showInfo(withStatus: "email_invalid".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if password.count < 6 {
            SVProgressHUD.showInfo(withStatus: "password_Weak".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else{
            
            SVProgressHUD.show()
            // api code
            API().login(email: email, password: password) { (success: Bool, error: Int) in
                SVProgressHUD.dismiss()
                if success{
                    SVProgressHUD.showSuccess(withStatus: "successfullyـlogin".localized())
                    SVProgressHUD.dismiss(withDelay: 2)
                    if error == 1{
                    let vc = UIStoryboard(name: "Main", bundle: nil)
                    let rootVc = vc.instantiateViewController(withIdentifier: "userIDID")
                    self.present(rootVc, animated: true, completion: nil)
                    }else{
                        let vc = UIStoryboard(name: "Main", bundle: nil)
                        let rootVc = vc.instantiateViewController(withIdentifier: "homeID")
                        self.present(rootVc,animated: true,completion: nil)
                    }
                }else{
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: "failed_Login".localized())
                    SVProgressHUD.dismiss(withDelay: 2)
                    print("the error \(error)")
                }
            }
        }
            
        }else{
            SVProgressHUD.showInfo(withStatus: "no_internet_connection".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }
        
        
        
    }
    @IBAction func signUpBtn(_ sender: Any) {
    performSegue(withIdentifier: "signUpSegue", sender: self)
    }
    
    
    

}
