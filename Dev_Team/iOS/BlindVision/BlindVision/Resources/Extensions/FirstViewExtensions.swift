//
//  callAPI.swift
//  BlindVision
//
//  Created by Hoàng Sơn Tùng on 3/26/19.
//  Copyright © 2019 Hoàng Sơn Tùng. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import Emojimap
import JGProgressHUD

let urlAPI = NSURL(string: "http://52.163.230.167:5000/v1/api/predict")

public protocol URLConvertible {
    func asURL() throws -> URL
}

extension FirstViewController {
    
    //Call Object detech API
    func callAPIObjectDetect(imgDataBase64: String, imgName: String) {
        let param = [
            "image": imgDataBase64,
            "name": imgName
        ]
        
        let APIEndpoint: String = "http://52.163.230.167:5000/v1/api/predict"
        let request: [String: Any] = ["image": imgDataBase64, "name": imgName]
        
        Alamofire.request(APIEndpoint, method: .post, parameters: request,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling POST")
                    print(response.result.error!)
                    return
                }
                // make sure we got some JSON
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get object as JSON from API")
                    print("Error: \(response.result.error)")
                    return
                }
                // get and print the title
                guard let predict = json["predict"] as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
                
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.sync {
                        self.objectLabel.text = self.cleanPredictData(predict: predict)
                    }
                }
        }
    }
    
    func cleanPredictData(predict: String) -> String {
        
        /*
         **** @result: output string
         **** @dictionary: insert all object can found, count number appear times
        */
        var result: String
        var dictionary = [String: Int]()
        
        var strArray = predict.components(separatedBy: "\'")
        let trash: Set<String> = [ "[", ", " , "]" , "[]" ]
        strArray.removeAll(where: { trash.contains($0) })
        dictionary = strArray.reduce(into: [:]) { counts, word in counts[word, default: 0] += 1 }
        result=""
        for (object, number) in dictionary {
            //Match emoji to add to string
            let mapping = EmojiMap()
            for match in mapping.getMatchesFor(object) {
                result+="\(number) \(object) \(match.emoji), "
                break
            }
        }
        print(result)
        
        //Check and remove last space unexpected
        let checking = result.suffix(2)
        if (checking == ", ") {
            result = String(result.dropLast(2))
        }
        
        //Check if not recognized object
        if (result == "" || result == "()") {
            result = "I don't know! 👽"
        }
        return result
    }
    
    //Assigned name to captured photos, so they can filled in body request
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func addFloatingView(previewView: UIView) {
        let widthScreen = previewView.bounds.width
        let floatingView = BlurredRoundedView(frame: CGRect(x: (widthScreen-320)/2, y: 60, width: 320, height: 80))
        previewView.addSubview(floatingView)
    }
    
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
    
    
    func incrementHUD(_ hud: JGProgressHUD, progress previousProgress: Int) {
        let progress = previousProgress + 2 //+2 means speed of indicator
        hud.progress = Float(progress)/100.0
        hud.detailTextLabel.text = "\(progress)% Complete"
        
        if progress == 100 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                UIView.animate(withDuration: 0.1, animations: {
                    hud.textLabel.text = "Success"
                    hud.detailTextLabel.text = nil
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                })
                
                hud.dismiss(afterDelay: 1.0)
                }
            }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(20)) {
                self.incrementHUD(hud, progress: progress)
            }
        }
    }
    
    func showLoadingHUD() {
        let hud = JGProgressHUD(style: .light)
        hud.vibrancyEnabled = false
        if arc4random_uniform(2) == 0 {
            hud.indicatorView = JGProgressHUDPieIndicatorView()
        }
        else {
            hud.indicatorView = JGProgressHUDRingIndicatorView()
        }
        hud.detailTextLabel.text = "0% Complete"
        hud.textLabel.text = "Analyzing"
        hud.show(in: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
            self.incrementHUD(hud, progress: 0)
        }
    }
}
