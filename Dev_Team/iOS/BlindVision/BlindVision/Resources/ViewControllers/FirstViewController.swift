//
//  FirstViewController.swift
//  BlindVision
//
//  Created by Hoàng Sơn Tùng on 3/21/19.
//  Copyright © 2019 Hoàng Sơn Tùng. All rights reserved.
//

import UIKit
import AVFoundation

class FirstViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var objectLabel: UILabel!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var widthScreenScale = 0.0, heightScreenScale = 0.0
    let uploadWidth = 720, uploadHeight = 1280
    
    //When user tap on camera
    @IBAction func didTakePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
        TapticEffectsService.performTapticFeedback(from: TapticEffectsService.TapticEngineFeedbackIdentifier.pop)
    }
    
    //Handle the captured photo
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }

        // @image: AVCapture --> UI Image
        var image = UIImage(data: imageData)
    
        let LiveViewProcessor = LiveViewProcessing()
        image = LiveViewProcessor.resizeImage(image: image!, targetSize: CGSize.init(width: uploadWidth, height: uploadHeight))
        
        //Convert UIImage -> jpeg -> base64
        
        guard let imgData = image?.jpegData(compressionQuality: 0.0) else {
            return()
        }
        let imgDataBase64 = imgData.base64EncodedString()
        let imgName = randomString(length: 5) + ".jpg"
        
        let result = self.callAPIObjectDetect(imgDataBase64: imgDataBase64, imgName: imgName, scaleWidth: widthScreenScale, scaleHeight: heightScreenScale)
        showLoadingHUD()
        print(result)
    }
    
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        
        //Get the scale ratio
        let widthScreen = previewView.bounds.width
        let heightScreen = previewView.bounds.height
        widthScreenScale = Double(widthScreen)/Double(uploadWidth)
        heightScreenScale = Double(heightScreen)/Double(uploadHeight)
        
        print(widthScreenScale, heightScreenScale)
        
        //Add FloatingView on top
        addFloatingView(previewView: previewView, x: Int((widthScreen-320)/2), y: 60, width: 320, height: 80)
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }
    
    func pushCameraToController() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd1920x1080
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pushCameraToController()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
}

