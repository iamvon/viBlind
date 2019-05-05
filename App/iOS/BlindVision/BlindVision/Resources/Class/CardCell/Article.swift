//
//  Article.swift
//  BlindVision
//
//  Created by Hoàng Sơn Tùng on 4/13/19.
//  Copyright © 2019 Hoàng Sơn Tùng. All rights reserved.
//

import Foundation
import UIKit
class Article {
    let title: String!
    let topic: String!
    let content: String!
    let id: Int!
    let date: String!
    let introduction: String!
    let url: String!
    let hash: String!
    
    init(id: Int, date: String, topic: String, title: String, introduction: String, content: String, url: String, hash: String) {
        self.topic = topic
        self.title = title
        self.content = content
        self.id = id
        self.date = date
        self.introduction = introduction
        self.url = url
        self.hash = hash
    }
}
