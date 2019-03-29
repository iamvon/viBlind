//
//  Object.swift
//  BlindVision
//
//  Created by Hoàng Sơn Tùng on 3/27/19.
//  Copyright © 2019 Hoàng Sơn Tùng. All rights reserved.
//

import Foundation

class Object {
    var name: String = "";
    var height: Int;
    var width: Int;
    var x: Int;
    var y: Int;
    var confidence : Float;
    
    init(name: String, height: Int, width: Int, x: Int, y: Int, confidence: Float) {
        self.name = name;
        self.height = height;
        self.width = width;
        self.x = x;
        self.y = y;
        self.confidence = confidence;
    }
}
