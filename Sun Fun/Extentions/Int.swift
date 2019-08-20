//
//  Int.swift
//  Sun Fun
//
//  Created by arab devolpers on 8/4/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import Foundation
extension Int {
    public var asWord: String {
        let numberValue = NSNumber(value: self)
        var formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        return formatter.string(from: numberValue)!
    }
}
