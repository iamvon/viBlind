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
import JGProgressHUD

let urlAPI = NSURL(string: "http://52.163.230.167:5000/v1/api/predict")

public protocol URLConvertible {
    func asURL() throws -> URL
}


extension FirstViewController {
    
    //Call Object detech API
    func callAPIObjectDetect(imgDataBase64: String, imgName: String)-> [Object] {
        let APIEndpoint: String = "http://52.163.230.167:5000/v1/api/predict"
        let request: [String: Any] = ["image": imgDataBase64, "name": imgName]
        
        var objects = [Object]()
        
        //Create a StringProcess class, so can call function processing object name to result label
        let processString = StringProcess()
        
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
                        
                        // Parse JSON to array of object
                        for (_, subJson) in json["objectProperty"]{
                            if let text = subJson["text"].string {
                                processString.appendItem(x: text)
                            }
                            let objectTemp = Object.init(
                                name: subJson["text"].string!,
                                height: subJson["height"].int!,
                                width: subJson["width"].int!,
                                x: subJson["x"].int!,
                                y: subJson["y"].int!,
                                confidence: subJson["confidence"].float!)
                            objects.append(objectTemp)
                        }
                    }catch{
                        print("Unexpected error: \(error).")
                    }
                    
                    if !(objects.count==0) {
                        print(objects[0].confidence)
                    }
                    DispatchQueue.global(qos: .userInitiated).async {
                        DispatchQueue.main.sync {
                            self.objectLabel.text = processString.LabelCountingToResult()
                            TapticEffectsService.performTapticFeedback(from: TapticEffectsService.TapticEngineFeedbackIdentifier.tryAgain)
                            let LiveViewProcessor = LiveViewProcessing()
                            self.previewView = LiveViewProcessor.removeAllBoundingBox(LiveView: self.previewView! )
                            self.previewView = LiveViewProcessor.addToLiveView(LiveView: self.previewView!, observations: objects)
                        }
                    }
                }
        }
        print(objects)
        return objects
    }
    
    //Assigned name to captured photos, so they can filled in body request
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    //Add floating(blur, shadow, transluency) view to the screen
    func addFloatingView(previewView: UIView) {
        let widthScreen = previewView.bounds.width
        let floatingView = BlurredRoundedView(frame: CGRect(x: (widthScreen-320)/2, y: 60, width: 320, height: 80))
        previewView.addSubview(floatingView)
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

