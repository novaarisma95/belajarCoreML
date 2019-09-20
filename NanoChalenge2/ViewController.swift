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
import CoreLocation //step 1cl

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate , CLLocationManagerDelegate
{
    @IBOutlet weak var nama: UILabel!
    
    //step2cl
    var locationManager :CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //step3 cl
        self.locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        self.locationManager.delegate = self
        
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
        
        guard let model = try? VNCoreMLModel(for: people2 ().model) else {return}
        let request = VNCoreMLRequest(model: model)
        { (finishedReq, err) in
            
            //perhaps check the err
            //print(finishedReq.results)
            
            guard let results = finishedReq.results as?
                [VNClassificationObservation] else {return}
            
            guard let firstObservation = results.first else {return}
            print(firstObservation.identifier, firstObservation.confidence)
            DispatchQueue.main.async {
                self.nama.text = "\(firstObservation.identifier) -  \( firstObservation.confidence)"
            }
            
            
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixxelBuffer, options: [:]).perform([request])
    }
    
    func setUpGeofanceForFriend()
    {
        let geofanceRegionCenter = CLLocationCoordinate2DMake(-6.3023, 106.6522)
        let geofanceRegion = CLCircularRegion(center: geofanceRegionCenter, radius: 50, identifier: "CurrentLocation")
        geofanceRegion.notifyOnExit = true
        geofanceRegion.notifyOnEntry = true
    self.locationManager.startMonitoring(for: geofanceRegion)
    
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
    {
        print ("Find Your Friend : \(region.identifier)")
        
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        setUpGeofanceForFriend()
    }
    
}



