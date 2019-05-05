//
//  SpeechConnector.swift
//  SpeechInjector
//
//  Created by Richard Simpson on 26/12/2018.
//  Copyright © 2018 Richard Simpson. All rights reserved.
//

import Foundation
protocol SpeechConnectorProtocol {
    var words : [String] { get }
    var link : String { get }
}

public class SpeechConnector {
    var words : [String]
    var actionClosure :(() -> ())
    
    public init(words:String... , actionClosure :@escaping (() -> ())) {
        self.words = words
        self.actionClosure = actionClosure
    }
}
