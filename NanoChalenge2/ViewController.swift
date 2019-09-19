//
//  ViewController.swift
//  NanoChalenge2
//
//  Created by Nova Arisma on 9/19/19.
//  Copyright © 2019 Nova Arisma. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // here start up camera
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput (device:captureDevice) else {return}
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session : captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate( self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
        //let requiest = VNCoreMLRequest(model: <#T##VNCoreMLModel#>)
        //VNImageRequestHandler(cgImage: <#T##CGImage#>, options: [:]).perform(<#T##requests: [VNRequest]##[VNRequest]#>)
        
    }
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        //print("Camera was able to capture a frame:", Date())
        
        guard let pixxelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        
        guard let model = try? VNCoreMLModel(for: people2().model) else {return}
        let request = VNCoreMLRequest(model: model)
        { (finishedReq, err) in
            
            //perhaps check the err
            //print(finishedReq.results)
            
            guard let results = finishedReq.results as?
                [VNClassificationObservation] else {return}
            
            guard let firstObservation = results.first else {return}
            print(firstObservation.identifier, firstObservation.confidence)
            
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixxelBuffer, options: [:]).perform([request])
    }
    
    }



