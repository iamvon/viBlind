//
//  VoiceRecognizeController.swift
//  BlindVision
//
//  Created by Hoàng Sơn Tùng on 5/3/19.
//  Copyright © 2019 Hoàng Sơn Tùng. All rights reserved.
//

import Foundation
import UIKit
import Speech
import SpeechInjector
class VoiceRecognizeController: UIViewController, SFSpeechRecognizerDelegate {
    
    var injector : SpeechInjector!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var answerView: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
         TapticEffectsService.performTapticFeedback(from: TapticEffectsService.TapticEngineFeedbackIdentifier.peek)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        TapticEffectsService.performTapticFeedback(from: TapticEffectsService.TapticEngineFeedbackIdentifier.peek)
    }
    
    var articleHash: String = ""
    var answerData: [Answer] = []
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    let vc = VoiceOver()
    
    override func viewDidLoad() {
        print(articleHash)
        
//        var dem = 0
//        while (answerData.isEmpty) {
//            answerData = callAPIAnswering(question: "Who is Queen Suthida?", hash_url: "7B0CB90EF03871F37F478EF01991AF2F032EC5BA")
//            dem+=1
//            sleep(3)
//            print(dem)
//        }
        
        vc.sayThis("What can I help you with?")
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        
        super.viewDidLoad()
        
        microphoneButton.isEnabled = false
        
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
        
        let connector1 = SpeechConnector(words: "back", "fight", "bank") {
            self.navigationController?.popViewController(animated: true)
        }
        
        injector = SpeechInjector(connectors: [connector1], vc: self, language: "en-US")
        
        injector.placeSpeechButton(buttonColor: UIColor(red:0.34, green:0.67, blue:0.18, alpha:1.0), yOffset: 65)
    }
    
    @IBAction func microphoneTapped(_ sender: AnyObject) {
         TapticEffectsService.performTapticFeedback(from: TapticEffectsService.TapticEngineFeedbackIdentifier.cancelled)
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            microphoneButton.setTitle("Start Recording", for: .normal)
//            startRecording()
           
            //CALL API ANSWERING
            answerView.text = "Hmmm...let me think!"
            vc.sayThis(answerView.text)
            print(articleHash)
            answerData = callAPIAnswering(question: textView.text, hash_url: articleHash)
            
            
        } else {
            startRecording()
            microphoneButton.setTitle("Stop Recording", for: .normal)
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {  //1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()  //2
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //3
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        } //5
        
        recognitionRequest.shouldReportPartialResults = true  //6
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in  //7
            
            var isFinal = false  //8
            
            if result != nil {
                
                self.textView.text = result?.bestTranscription.formattedString  //9
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {  //10
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()  //12
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        textView.text = "Say something, I'm listening!"
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    
    func receivedAnswer() {
        var result = ""
        
        let threadhold: Float = 0.00005 //Well, i have to set it for fun since QA API so fucking fucking bad
        if !answerData.isEmpty {
            let finalAnswer = answerData[0]
            if (finalAnswer.score <= threadhold) {
                result = "I don't know!"
            } else {
                result = finalAnswer.result
            }
        } else {
            result = "Please ask again!"
        }
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.sync {
                TapticEffectsService.performTapticFeedback(from: TapticEffectsService.TapticEngineFeedbackIdentifier.pop)
                self.answerView.text = result
                self.vc.sayThis(result)
            }
        }
    }
}
