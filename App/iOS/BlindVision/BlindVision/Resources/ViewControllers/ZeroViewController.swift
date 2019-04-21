//
//  SecondViewController.swift
//  BlindVision
//
//  Created by Hoàng Sơn Tùng on 3/21/19.
//  Copyright © 2019 Hoàng Sơn Tùng. All rights reserved.
//

import UIKit

class ZeroViewController: UIViewController {

    @IBOutlet weak var StartButton: UIButton!
    
    @IBAction func touchStart(_ sender: Any) {
        TapticEffectsService.performTapticFeedback(from: TapticEffectsService.TapticEngineFeedbackIdentifier.pop)
    }
    
    override func viewDidLoad() {
        StartButton.layer.cornerRadius = 0.5 * StartButton.bounds.size.width // add the round corners in proportion to the button size
        
        let blur = UIVisualEffectView(effect: UIBlurEffect(style:
            UIBlurEffect.Style.light))
        blur.frame = StartButton.bounds
        blur.isUserInteractionEnabled = false //This allows touches to forward to the button.
        StartButton.insertSubview(blur, at: 0)
        blur.layer.cornerRadius = 0.1 * StartButton.bounds.size.width
        blur.clipsToBounds = true
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

