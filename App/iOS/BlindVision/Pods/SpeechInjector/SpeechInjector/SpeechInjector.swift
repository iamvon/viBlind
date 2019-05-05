//
//  SpeechInjector.swift
//  SpeechInjector
//
//  Created by Richard Simpson on 26/12/2018.
//  Copyright © 2018 Richard Simpson. All rights reserved.
//

import Foundation
import Speech
import MaterialComponents.MaterialButtons

public class SpeechInjector {
    
    public enum SpeechButtonLocation {
        case letftTop, rightTop, leftBottom, rightBottom
    }
    
    // Private class variables
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var speechResult = SFSpeechRecognitionResult()
    private var speechButton : MDCFloatingButton!
    private var buttonColor: UIColor!
    private var buttonRecordingColor: UIColor!
    
    // Init setters
    
    private weak var vc : UIViewController?
    private let connectors : [SpeechConnector]
    private var speechRecognizer : SFSpeechRecognizer
    
    public init(connectors:[SpeechConnector],
                vc:UIViewController,
                language: String = "nl-NL") {
        
        self.connectors = connectors
        self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: language))!
        self.vc = vc 
    }
    
    // MARK: Private functions
    @objc private func _buttonAction(sender: UIButton!) {
        _startSpeechRecording()
    }
    
    private func _startSpeechRecording() {
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            
            OperationQueue.main.addOperation {
                var alertTitle = ""
                var alertMsg = ""
                
                switch authStatus {
                case .authorized:
                    do {
                        try self._startRecording()
                    } catch {
                        alertTitle = "Recorder Error"
                        alertMsg = "There was a problem starting the speech recorder"
                    }
                    
                case .denied:
                    alertTitle = "Speech recognizer not allowed"
                    alertMsg = "You enable the recognizer in Settings"
                    
                case .restricted, .notDetermined:
                    alertTitle = "Could not start the speech recognizer"
                    alertMsg = "Check your internect connection and try again"
                    
                }
                
                if alertTitle != "" {
                    let alert = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                        self.vc!.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.vc!.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc private func _timerEnded() {
        // If the audio recording engine is running stop it and remove the SFSpeechRecognitionTask
        _setButtonColor()
        if audioEngine.isRunning {
            _stopRecording()
        }
    }
    
    private func _stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        
        // Cancel the previous task if it's running
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
    }
    
    private func _startRecording() throws {
        if !audioEngine.isRunning {
            let timer = Timer(timeInterval: 5.0, target: self, selector: #selector(_timerEnded), userInfo: nil, repeats: false)
            RunLoop.current.add(timer, forMode: .common)
            
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            
            let inputNode = audioEngine.inputNode
            guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create the recognition request") }
            
            // Configure request so that results are returned before audio recording is finished
            recognitionRequest.shouldReportPartialResults = true
            
            // A recognition task is used for speech recognition sessions
            // A reference for the task is saved so it can be cancelled
            var triggeredByResult = false // makes sure all custom user actions are peformed only ones!
            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
                var isFinal = false
                
                if let result = result {
                    //   print("result: \(result.isFinal)")
                    isFinal = result.isFinal
                    
                    self.speechResult = result
                    
                    debugPrint(" captured word: \(result.bestTranscription.formattedString.lowercased()) ")
                    
                    let receivedSpeech = self.speechResult.bestTranscription.formattedString.lowercased()
                    self.connectors.forEach({ (sc) in
                        
                        let words = sc.words.filter{ $0 == receivedSpeech }.count
                        if words > 0,  !triggeredByResult {
                            triggeredByResult.toggle()
                            self._setButtonColor()
                            sc.actionClosure()
                        }
                    })
                }
                
                if error != nil || isFinal {
                    
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    
                }
            }
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                self.recognitionRequest?.append(buffer)
            }
            
            print("Begin recording")
            _setRecordingColor()
            
            audioEngine.prepare()
            try audioEngine.start()
        }
    }
    
    private func _speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        print("Recognizer availability changed: \(available)")
        
        if !available {
            let alert = UIAlertController(title: "There was a problem accessing the recognizer", message: "Please try again later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                self.vc!.dismiss(animated: true, completion: nil)
            }))
            
            self.vc!.present(alert, animated: true, completion: nil)
        }
    }
    
    private func _setRecordingColor() {
        speechButton.backgroundColor = buttonRecordingColor
    }
    
    private func _setButtonColor() {
        speechButton.backgroundColor = buttonColor
    }
    
    private func _returnSafeAreaSize() -> (top:CGFloat,bottom:CGFloat) {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136,1334, 1920, 2208:
                return (0,0)
            case 2688, 2436,1792:
                return(44,38) 
            default:
                return(0,0)
            }
        }
        return(0,0)
    }
    
    // MARK: Public function
    public func placeSpeechButton(position : SpeechButtonLocation = .rightBottom,
                                  buttonColor: UIColor = UIColor(red:0.30, green:0.50, blue:0.70, alpha:1.0) ,
                                  buttonRecordingColor :UIColor = UIColor(red:0.94, green:0.17, blue:0.18, alpha:1.0),
                                  buttonHeight:CGFloat = 60 ,
                                  buttonWidth : CGFloat = 60,
                                  xOffset: CGFloat = 16,
                                  yOffset : CGFloat = 16,
                                  image : UIImage? = nil,
                                  tintColor : UIColor = UIColor.white, elevationNormalState: CGFloat = 6.0,
                                  elevationHighlightedState : CGFloat =  12.0) {
        
    
        self.buttonColor = buttonColor
        self.buttonRecordingColor = buttonRecordingColor
        speechButton = MDCFloatingButton(frame: CGRect(x: 60, y: 60, width: buttonWidth, height: buttonHeight))
        
        let bundle = Bundle(for: SpeechInjector.self)
        var finalImage = image
        if finalImage == nil {
            finalImage = UIImage(named: "speech", in: bundle, compatibleWith: nil)
        }
        
        let speechImage = finalImage!.withRenderingMode(.alwaysTemplate)
        speechButton.tintColor = tintColor
        _setButtonColor()
        speechButton.setImage(speechImage, for: .normal)
        speechButton.isUserInteractionEnabled = true
        speechButton.setElevation(ShadowElevation(rawValue: elevationNormalState), for: .normal)
        speechButton.setElevation(ShadowElevation(rawValue: elevationHighlightedState), for: .highlighted)
        
        var xPos : CGFloat = 0.0
        var yPos : CGFloat = 0.0
        
        switch position {
        case .leftBottom:
            xPos = xOffset
            yPos = vc!.view.frame.height - speechButton.frame.height - yOffset -  _returnSafeAreaSize().bottom
        case .letftTop :
            xPos = xOffset
            yPos = yOffset - _returnSafeAreaSize().top
            
        case .rightBottom :
            xPos = vc!.view.frame.width - speechButton.frame.width - xOffset
            yPos = vc!.view.frame.height - speechButton.frame.height - yOffset - _returnSafeAreaSize().bottom
            
        case .rightTop :
            xPos = vc!.view.frame.width - speechButton.frame.width - xOffset - _returnSafeAreaSize().top
            yPos = yOffset
        }
        
        vc!.view.addSubview(speechButton)
        
        speechButton.addTarget(self, action: #selector(_buttonAction(sender:)), for: .touchUpInside)
        speechButton.frame.origin.x = xPos
        speechButton.frame.origin.y = yPos
    }
}



