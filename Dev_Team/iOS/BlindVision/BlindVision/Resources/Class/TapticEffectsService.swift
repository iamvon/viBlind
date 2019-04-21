//
//  TapticEffectsService.swift
//
//
//  Created by Serhii Kharauzov on 10/19/17.
//  Copyright © 2017 Serhii Kharauzov. All rights reserved.
//

import Foundation
import AudioToolbox.AudioServices
import UIKit

class TapticEffectsService {
    
    // MARK: Public type methods - Haptic Feedback
    
    /// Performs haptic feedback - selection.
    static func performFeedbackSelection() {
        if #available(iOS 10.0, *) {
            guard UIDevice.current.hasHapticFeedback else { return }
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.prepare()
            selectionFeedbackGenerator.selectionChanged()
        }
    }
    
    /// Performs haptic feedback - impact.
    static func performFeedbackImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        if #available(iOS 10.0, *) {
            guard UIDevice.current.hasHapticFeedback else { return }
            let mediumImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: style)
            mediumImpactFeedbackGenerator.prepare()
            mediumImpactFeedbackGenerator.impactOccurred()
        }
    }
    
    /// Performs haptic feedback - notification.
    static func performFeedbackNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
        if #available(iOS 10.0, *) {
            guard UIDevice.current.hasHapticFeedback else { return }
            let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
            notificationFeedbackGenerator.prepare()
            notificationFeedbackGenerator.notificationOccurred(type)
        }
    }
    
    // MARK: Public type methods - Taptic Engine
    
    /// Performs taptic feedback based on 'TapticEngineFeedbackIdentifier'.
    static func performTapticFeedback(from feedbackIdentifier: TapticEngineFeedbackIdentifier) {
        if UIDevice.current.hasTapticEngine {
            AudioServicesPlaySystemSound(feedbackIdentifier.rawValue)
        }
    }
}

extension TapticEffectsService {
    enum TapticEngineFeedbackIdentifier: UInt32 {
        /// 'Peek' feedback (weak boom)
        case peek = 1519
        /// 'Pop' feedback (strong boom)
        case pop = 1520
        /// 'Cancelled' feedback (three sequential weak booms)
        case cancelled = 1521
        /// 'Try Again' feedback (week boom then strong boom)
        case tryAgain = 1102
        /// 'Failed' feedback (three sequential strong booms)
        case failed = 1107
    }
}

// MARK: UIDevice extension

extension UIDevice {
    enum DevicePlatform: String {
        case other = "Old Device"
        case iPhone6S = "iPhone 6S"
        case iPhone6SPlus = "iPhone 6S Plus"
        case iPhone7 = "iPhone 7"
        case iPhone7Plus = "iPhone 7 Plus"
        case iPhone8 = "iPhone 8"
        case iPhone8Plus = "iPhone 8 Plus"
        case iPhoneX = "iPhone X"
    }
    
    var platform: DevicePlatform {
        var sysinfo = utsname()
        uname(&sysinfo)
        let platform = String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        switch platform {
        case "iPhone10,3", "iPhone10,6":
            return .iPhoneX
        case "iPhone10,2", "iPhone10,5":
            return .iPhone8Plus
        case "iPhone10,1", "iPhone10,4":
            return .iPhone8
        case "iPhone9,2", "iPhone9,4":
            return .iPhone7Plus
        case "iPhone9,1", "iPhone9,3":
            return .iPhone7
        case "iPhone8,2":
            return .iPhone6SPlus
        case "iPhone8,1":
            return .iPhone6S
        default:
            return .other
        }
    }
    
    /// Enabled from iPhone6/iPhone6Plus.
    var hasTapticEngine: Bool {
        return platform != .other
    }
    
    /// Enabled from iPhone7/iPhone7Plus.
    var hasHapticFeedback: Bool {
        return [.iPhone7, .iPhone7Plus, .iPhone8, .iPhone8Plus, .iPhoneX].contains(platform)
    }
}
