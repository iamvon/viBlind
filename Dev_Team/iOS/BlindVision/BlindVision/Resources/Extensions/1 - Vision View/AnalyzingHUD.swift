//
//  AnalyzingHUD.swift
//  BlindVision
//
//  Created by Hoàng Sơn Tùng on 3/30/19.
//  Copyright © 2019 Hoàng Sơn Tùng. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD

extension FirstViewController {
    
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
