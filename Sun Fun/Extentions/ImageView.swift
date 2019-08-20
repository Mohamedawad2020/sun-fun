//
//  ImageView.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/27/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import Foundation
import UIKit
extension UIImageView{
    func circleImage(){
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 1.5
    }
    func roundCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.gray.cgColor
    }
}
