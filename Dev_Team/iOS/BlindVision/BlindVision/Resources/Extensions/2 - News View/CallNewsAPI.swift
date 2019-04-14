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
import AVFoundation
let urlNewsAPI = NSURL(string: "http://52.163.230.167:8080/v1/api/article?amount=40")

public protocol NewsURLConvertible {
    func asURL() throws -> URL
}


extension SecondViewController {
    
    //Call Object detech API
    func callAPINews()-> [Article] {
        let APIEndpoint: String = "http://52.163.230.167:8080/v1/api/article?amount=40"
        
        var Articles = [Article]()
        
        //Create a StringProcess class, so can call function processing object name to result label
        let processString = StringProcess()
        
        Alamofire.request(APIEndpoint, method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
//                print("Request: \(String(describing: response.request))")   // original url request
//                print("Response: \(String(describing: response.response))") // http url response
//                print("Result: \(response.result)")                         // response serialization result
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                    print("Data: \(utf8Text)") // original server data as UTF8 string
                    do{
                        // Get json data
                        let json = try JSON(data: data)
//                        print(json)
                        // Parse JSON to array of object
                        for item in json["articleDetail"].arrayValue {
                            let id = item["id"].stringValue
                            let date = item["date"].stringValue
                            let topic = item["topic"].stringValue
                            let title = item["title"].stringValue
                            let introduction = item["introduction"].stringValue
                            let content = item["content"].stringValue
                            let url = item["url"].stringValue
                            
                            let articleTemp = Article(id: Int(id)!, date: date, topic: topic, title: title, introduction: introduction, content: content, url: url)
                            Articles.append(articleTemp)
                        }
                    }catch{
                        print("Unexpected error: \(error).")
                    }
                    DispatchQueue.global(qos: .userInitiated).async {
                        DispatchQueue.main.sync {
                            
                            self.Data = Articles
                            self.cardSwiper.reloadData()

                        }
                    }
                }
        }
        return Articles
    }
    
}

