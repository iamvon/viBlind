//
//  BlurRoundedView.swift
//  BlindVision
//
//  Created by Hoàng Sơn Tùng on 3/26/19.
//  Copyright © 2019 Hoàng Sơn Tùng. All rights reserved.
//

import Foundation
import UIKit

let extraLightBlur = UIBlurEffect(style: .extraLight)
let cornerRadius : CGFloat = 8

class BlurredRoundedView: UIView {
    let effectBackground = UIVisualEffectView(effect: extraLightBlur)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit()  {
        initLayer()
        initEffectView()
    }
    
    func initLayer() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
    }
    
    func initEffectView() {
        effectBackground.frame = bounds
        effectBackground.layer.cornerRadius = cornerRadius
        effectBackground.layer.masksToBounds = true
        
        addSubview(effectBackground)
        sendSubviewToBack(effectBackground)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 4
        layer.shadowPath = shadowPath.cgPath
    }
}
