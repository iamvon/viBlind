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
        
        var items = [String]()
        Alamofire.request(APIEndpoint, method: .post, parameters: request,
                          encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                //print("Request: \(String(describing: response.request))")   // original url request
                //print("Response: \(String(describing: response.response))") // http url response
                //print("Result: \(response.result)")                         // response serialization result
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                    do{
                        // Get json data
                        let json = try JSON(data: data)
                        print(json)
                        // Loop sub-json countries array
                        for (_, subJson) in json["objectProperty"]{
                            if let text = subJson["text"].string {
                                items.append(text)
                            }
                        }
                    }catch{
                        print("Unexpected error: \(error).")
                    }
                    
                // Convert items to an array of key-value pairs using tuples, where each value is the number 1
                    let mappedItems = items.map { ($0, 1) }
                
                // Create a Dictionary from that items array, asking it to add the 1s together every time it finds a duplicate key
                    let counts = Dictionary(mappedItems, uniquingKeysWith: +)
                    
                // Create resultLabel String
                    var resultLabel: String; resultLabel=""
                    if counts.isEmpty {
                        resultLabel = "I don't know! 👽"
                    } else {
                        for (item, numbers) in counts {
                            var emoji: String; emoji=""
                            let mapping = EmojiMap()
                            for match in mapping.getMatchesFor(item) {
                                    emoji = match.emoji
                                    break
                            }
                            resultLabel += "\(numbers) \(item) \(emoji), "
                        }
                    }
                    
                    //Check and remove last space unexpected
                    let checking = resultLabel.suffix(2)
                    if (checking == ", ") {
                        resultLabel = String(resultLabel.dropLast(2))
                    }
                
                print(resultLabel)
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.sync {
                       self.objectLabel.text = resultLabel
                       TapticEffectsService.performTapticFeedback(from: TapticEffectsService.TapticEngineFeedbackIdentifier.tryAgain)
                    }
                }
            }
        }
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
    
    /*-------------------------------------------------------------*/
    //***** Create a HUD analyzing while waiting for response
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
