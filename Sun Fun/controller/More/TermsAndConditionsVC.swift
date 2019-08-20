//
//  TermsAndConditionsVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/26/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit

class TermsAndConditionsVC: UIViewController {

    @IBOutlet weak var termView: UITextView!
    override func viewWillAppear(_ animated: Bool) {
        termView.isEditable = false
        termView.dropShadow()
        API().aboutUS(type: 2) { (success:Bool, result:String) in
            if success{
                self.termView.text = result
            }else{
                print("error")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        API().aboutUS(type: 2) { (success:Bool, result:String) in
//            if success{
//                self.termView.text = result
//            }else{
//                print("error")
//            }
//        }

    }
    

    

}
