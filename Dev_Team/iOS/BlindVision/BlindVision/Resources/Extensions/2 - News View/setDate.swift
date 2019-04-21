//
//  setDate.swift
//  BlindVision
//
//  Created by Hoàng Sơn Tùng on 4/12/19.
//  Copyright © 2019 Hoàng Sơn Tùng. All rights reserved.
//

import Foundation
import UIKit

extension SecondViewController {
    
    func setDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM yyyy"
        let myString = formatter.string(from: Date())
        Date_lb.text = myString
    }
}
