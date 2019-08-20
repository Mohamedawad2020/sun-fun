//
//  Extensions.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/17/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    func showAlert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ok".localized(), style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func alertdone(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "finish".localized(), style: .default, handler: { action in
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        let finishAction = UIAlertAction(title: "ok".localized(), style: .default, handler: nil)
        
        alertController.addAction(finishAction)
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

