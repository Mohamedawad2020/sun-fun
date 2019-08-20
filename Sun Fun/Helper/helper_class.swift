//
//  helper_class.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/18/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import Foundation
import UIKit
struct helper_class{
    func goToBooking(){
        let vc = UIStoryboard(name: "Main", bundle: nil)
        let rootVc = vc.instantiateViewController(withIdentifier: "bookingID")
        self.present(rootVc,animated: true,completion: nil)
    }
}
