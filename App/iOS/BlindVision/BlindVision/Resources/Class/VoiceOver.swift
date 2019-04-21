//
//  VoiceOver.swift
//  BlindVision
//
//  Created by Hoàng Sơn Tùng on 4/10/19.
//  Copyright © 2019 Hoàng Sơn Tùng. All rights reserved.
//

import Foundation
import AVFoundation
class VoiceOver {
    let voices = AVSpeechSynthesisVoice.speechVoices()
    let voiceSynth = AVSpeechSynthesizer()
    var voiceToUse: AVSpeechSynthesisVoice?
    
    init(){
        for voice in voices {
            if voice.name == "Samantha"  && voice.quality == .enhanced {
                voiceToUse = voice
            }
//            print(voice.name)
        }
    }
    
    func sayThis(_ phrase: String){
        let utterance = AVSpeechUtterance(string: phrase)
        utterance.voice = voiceToUse
        utterance.rate = 0.5
        
        voiceSynth.speak(utterance)
    }
    
    func sayThis(_ phrase: String, speed: Float){
            let utterance = AVSpeechUtterance(string: phrase)
            utterance.voice = voiceToUse
            utterance.rate = speed
            
            voiceSynth.speak(utterance)
    }
}
