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

    var labelFloatWidth = 0, labelFloatHeight = 0
    
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

    //Add floating(blur, shadow, transluency) view to the screen
    func addFloatingView(previewView: UIView, x: Int, y: Int, width: Int, height: Int) {
        let floatingView = BlurredRoundedView(frame: CGRect(x: x, y: y, width: width, height: height))
        floatingView.tag = 1
        previewView.addSubview(floatingView)
    }
    
    func addToLiveView(LiveView: UIView, observations: [Object], scaleWidth: Double, scaleHeight: Double)->UIView {
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
//            layer.frame = CGRect(x: x, y: y, width: w, height: h)
//            layer.borderColor = UIColor.yellow.cgColor
//            layer.borderWidth = 5
//            layer.cornerRadius = 3
//            layer.name = "BoundingBox"
//            LiveView.layer.addSublayer(layer)
            
            labelFloatWidth = Int(Double(w)*0.8)
            labelFloatHeight = 50
            addFloatingView(previewView: LiveView, x: x+(w-labelFloatWidth)/2, y: y+(h-labelFloatHeight)/3, width: labelFloatWidth, height: labelFloatHeight)
            let label:UILabel = UILabel(frame: CGRect(x: x+(w-labelFloatWidth)/2, y: y+(h-labelFloatHeight)/3, width: labelFloatWidth, height: labelFloatHeight))
            //label.backgroundColor = UIColor.white
            label.textAlignment = .center
            label.textColor = UIColor.lightGray
            label.text = "\(object.color) \(object.name)"
            label.adjustsFontSizeToFitWidth = true
            label.font = UIFont.systemFont(ofSize: 28)
            
            layer.shadowColor = UIColor.darkGray.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowOpacity = 0.9
            layer.shadowRadius = 4
            label.tag = 2 //Add tag so I can delete these layers later.
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
        for label in LiveView.subviews {
            if label.tag==1 || label.tag==2 {
                label.removeFromSuperview()
            }
        }
        return LiveView
    }
}
