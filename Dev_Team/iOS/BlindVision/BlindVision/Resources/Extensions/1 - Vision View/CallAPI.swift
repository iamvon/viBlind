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

let urlAPI = NSURL(string: "http://52.163.230.167:5000/v1/api/predict")

public protocol URLConvertible {
    func asURL() throws -> URL
}


extension FirstViewController {
    
    //Call Object detech API
    func callAPIObjectDetect(imgDataBase64: String, imgName: String, scaleWidth: Double, scaleHeight: Double)-> [Object] {
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
                                confidence: subJson["confidence"].float!,
                                color: subJson["color"].string!)
                            objectTemp.x = Int(Double(objectTemp.x)*scaleWidth)
                            objectTemp.y = Int(Double(objectTemp.y)*scaleHeight)
                            objectTemp.width = Int(Double(objectTemp.width)*scaleWidth)
                            objectTemp.height = Int(Double(objectTemp.height)*scaleHeight)
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
                            self.previewView = LiveViewProcessor.addToLiveView(LiveView: self.previewView!, observations: objects, scaleWidth: scaleWidth, scaleHeight: scaleHeight)
                        }
                    }
                }
        }
        print(objects)
        return objects
    }
    
}

