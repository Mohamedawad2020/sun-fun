//
//  ViewController.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/16/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import SVProgressHUD
class ViewController: UIViewController {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func loginBTN(_ sender: Any) {
        let email = emailTF.text!
        let password = passwordTF.text!
        
        if email.isEmpty {
            SVProgressHUD.show(withStatus: "email_required")
            SVProgressHUD.dismiss(withDelay: 2)
        }
        if password.isEmpty{
            SVProgressHUD.show(withStatus: "password_required")
            SVProgressHUD.dismiss(withDelay: 2)
        }
        
    }
    
}

