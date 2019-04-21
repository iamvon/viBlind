//
//  leftMarginLargeTitle.swift
//  BlindVision
//
//  Created by Hoàng Sơn Tùng on 4/12/19.
//  Copyright © 2019 Hoàng Sơn Tùng. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

extension SecondViewController {
    
    func setLeftMarginTitle() {
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 10 // This is added to the default margin
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.paragraphStyle : style]
    }
}
