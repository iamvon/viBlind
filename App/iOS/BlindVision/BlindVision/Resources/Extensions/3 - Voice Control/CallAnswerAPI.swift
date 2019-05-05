//
//  callAPI.swift
//  BlindVision
//
//  Created by Hoàng Sơn Tùng on 5/5/19.
//  Copyright © 2019 Hoàng Sơn Tùng. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import AVFoundation
let answerNewsAPI = NSURL(string: "http://52.163.230.167:5000/v1/api/answer_question")

public protocol AnswerURLConvertible {
    func asURL() throws -> URL
}


extension VoiceRecognizeController {
    
    //Call Object detech API
    func callAPIAnswering(question: String, hash_url: String)-> [Answer] {
        let APIEndpoint: String = "http://52.163.230.167:5000/v1/api/answer_question"
        
        var Answers = [Answer]()
        
        let request: [String: Any] = ["question": question, "hash_url": hash_url]
        //Create a StringProcess class, so can call function processing object name to result label
        let processString = StringProcess()
        
        Alamofire.request(APIEndpoint, method: .post, parameters: request,
                          encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
//                                print("Request: \(String(describing: response.request))")   // original url request
//                                print("Response: \(String(describing: response.response))") // http url response
                                print("Result: \(response.result)")                         // response serialization result
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                    do{
                        // Get json data
                        let json = try JSON(data: data)
                        print(json)
                        
                        // Parse JSON to array of object
                        for (_, subJson) in json["answers"]{
                            let answerTemp = Answer.init(
                                result: subJson["result"].string!,
                                score: subJson["score"].float!
                                //                                color: subJson["color"].string!
                            )
                            Answers.append(answerTemp)
                        }
                    }catch{
                        print("Unexpected error: \(error).")
                    }
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        DispatchQueue.main.sync {
                                self.answerData = Answers
                                self.receivedAnswer()
                        }
                    }
                }
        }
        return Answers
    }
    
    
}

