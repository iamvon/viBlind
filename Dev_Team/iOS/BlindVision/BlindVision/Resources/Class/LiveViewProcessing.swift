//
//  AddBoundingBox.swift
//  BlindVision
//
//  Created by Hoàng Sơn Tùng on 3/27/19.
//  Copyright © 2019 Hoàng Sơn Tùng. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class LiveViewProcessing {
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height *      widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    func addToLiveView(LiveView: UIView, observations: [Object])->UIView {
        for (object) in observations {
            let w = object.width
            let h = object.height
            let x = object.x
            let y = object.y
            
            print("----")
            print("W: ", w)
            print("H: ", h)
            print("X: ", x)
            print("Y: ", y)
            
            let layer = CAShapeLayer()
            layer.frame = CGRect(x: (x/80)*46 , y: (y/80)*46, width: (w/80)*46, height: (h/80)*46)
            layer.borderColor = UIColor.yellow.cgColor
            layer.borderWidth = 5
            layer.cornerRadius = 3
            layer.name = "BoundingBox"
            LiveView.layer.addSublayer(layer)
            
            let label:UILabel = UILabel(frame: CGRect(x: (x/80)*46, y: (y/80)*46, width: 75, height: 35))
            label.backgroundColor = UIColor.white
            label.textColor = UIColor.orange
            label.text = object.name
            LiveView.addSubview(label)
            
        }
        return LiveView
    }
    
    func removeAllBoundingBox(LiveView: UIView)->UIView {
        for layer in LiveView.layer.sublayers! {
            if layer.name == "BoundingBox" {
                layer.removeFromSuperlayer()
            }
        }
        return LiveView
    }
}
