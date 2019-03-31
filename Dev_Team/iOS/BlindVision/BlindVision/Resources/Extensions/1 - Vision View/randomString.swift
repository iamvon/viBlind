//
//  GenerateImageName.swift
//  BlindVision
//
//  Created by Hoàng Sơn Tùng on 3/30/19.
//  Copyright © 2019 Hoàng Sơn Tùng. All rights reserved.
//

import Foundation

extension FirstViewController {
    
    //Assigned name to captured photos, so they can filled in body request
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
}
