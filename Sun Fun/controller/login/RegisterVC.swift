//
//  RegisterVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/16/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import SVProgressHUD
class RegisterVC: UIViewController {

    @IBOutlet weak var signB: UIButton!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    let user_type = UserDefaults.standard.integer(forKey: "user_type")
    let isArabic = UserDefaults.standard.bool(forKey: "is_arabic")
    override func viewWillAppear(_ animated: Bool) {
        signB.roundCorners(cornerRadius: 20.0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signInBtn(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func registerBtn(_ sender: Any) {
            if CheckInternet.Connection(){
          
            let userName = userNameTF.text!
            let password = passwordTF.text!
            let email = emailTF.text!
            let phone = phoneTF.text!
            
            if userName.isEmpty && password.isEmpty && email.isEmpty && phone.isEmpty{
                SVProgressHUD.showInfo(withStatus: "all_fields_required".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }else if userName.isEmpty{
                SVProgressHUD.showInfo(withStatus: "username_required".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }else if password.isEmpty{
                SVProgressHUD.showInfo(withStatus: "password_required".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }else if email.isEmpty{
                SVProgressHUD.showInfo(withStatus: "email_required".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }else if phone.isEmpty {
                SVProgressHUD.showInfo(withStatus: "phone_required".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }else if userName.count < 4 {
                SVProgressHUD.showInfo(withStatus: "username_invalid".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }else if !Validaton.isValidEmailAddress(emailAddressString: email){
                SVProgressHUD.showInfo(withStatus: "email_invalid".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            } else if password.count < 6 {
                SVProgressHUD.showInfo(withStatus: "password_Weak".localized())
                SVProgressHUD.dismiss(withDelay: 2)
            }else if phone.count < 10 {
                SVProgressHUD.showInfo(withStatus: "phone_invalid".localized())
                SVProgressHUD.dismiss(withDelay: 2)
                
            }else{
                SVProgressHUD.show()
                // api code
                API().register(name: userName, email: email, password: password, phone_code: "00966", phone: phone, software_type: 3) { (success: Bool, error: Int) in
                    SVProgressHUD.dismiss()
                    if success{
                        SVProgressHUD.showSuccess(withStatus: "successfullyـregistered".localized())
                        SVProgressHUD.dismiss(withDelay: 2)
                        if error == 1{
                            let vc = UIStoryboard(name: "Main", bundle: nil)
                            let rootVc = vc.instantiateViewController(withIdentifier: "userIDID")
                            self.present(rootVc, animated: true, completion: nil)
                        }else{
                                let vc = UIStoryboard(name: "Main", bundle: nil)
                                let rootVc = vc.instantiateViewController(withIdentifier: "homeID")
                                self.present(rootVc, animated: true, completion: nil)
                            }
                    }else{
                        SVProgressHUD.showError(withStatus: "failed_register".localized())
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
    

}
