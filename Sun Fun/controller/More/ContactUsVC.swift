//
//  ContactUsVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/26/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import SVProgressHUD
class ContactUsVC: UIViewController {

    @IBOutlet weak var sendBTN: UIButton!
    @IBOutlet weak var MessageTF: UITextView!
    @IBOutlet weak var subjectTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var userName: UITextField!
    let emailDefailt = UserDefaults.standard.string(forKey: "email")
    let usernameDefault = UserDefaults.standard.string(forKey: "name")
    
    override func viewWillAppear(_ animated: Bool) {
        userName.isEnabled = false
        userName.text = usernameDefault
        emailTF.isEnabled = false
        emailTF.text = emailDefailt
        sendBTN.roundCorners(cornerRadius: 5.0)
        MessageTF.roundCorners(cornerRadius: 10.0)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func send(_ sender: Any) {
        let name = userName.text!
        let email = emailTF.text!
        let subject = subjectTF.text!
        let message = MessageTF.text!
        if name.isEmpty && email.isEmpty && subject.isEmpty && message.isEmpty {
            SVProgressHUD.showInfo(withStatus: "all_fields_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if name.isEmpty {
            SVProgressHUD.showInfo(withStatus: "user_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if email.isEmpty{
            SVProgressHUD.showInfo(withStatus: "email_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if !Validaton.isValidEmailAddress(emailAddressString: email){
            SVProgressHUD.showInfo(withStatus: "email_invalid".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if subject.isEmpty{
            SVProgressHUD.showInfo(withStatus: "subject_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else if message.isEmpty{
            SVProgressHUD.showInfo(withStatus: "Message_required".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }else{
        // api code
            SVProgressHUD.show()
            More_API().contactUs(fname: name, email: email, subject: subject, message: message) { (success:Bool, error:String) in
                SVProgressHUD.dismiss()
                if success{
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showInfo(withStatus: "message_sent".localized())
                    SVProgressHUD.dismiss(withDelay: 2)
                    self.userName.text = ""
                    self.emailTF.text = ""
                    self.subjectTF.text = ""
                    self.MessageTF.text = ""
                    self.alertdone(message:"message_sent".localized() , title: "alarm".localized())
                }else{
                    SVProgressHUD.showInfo(withStatus: error)
                    SVProgressHUD.dismiss(withDelay: 2)
                }
            }
        }
        
        
        
        
        
        
        
    }
    

}
