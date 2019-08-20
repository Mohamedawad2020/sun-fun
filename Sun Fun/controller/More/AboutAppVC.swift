//
//  AboutAppVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/26/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit

class AboutAppVC: UIViewController {

    @IBOutlet weak var aboutView: UITextView!
    override func viewWillAppear(_ animated: Bool) {
        aboutView.isEditable = false
        aboutView.dropShadow()
        API().aboutUS(type: 1) { (success:Bool, result:String) in
            if success{
                self.aboutView.text = result
                print("result \(result)")
            }else{
                print("error")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    

}
