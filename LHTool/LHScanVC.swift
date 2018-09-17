//
//  LHScanVC.swift
//  LHTool
//
//  Created by 刘恒 on 2018/8/2.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit
import AVFoundation
class LHScanVC: UIViewController,AVCaptureMetadataOutputObjectsDelegate  {
    
    typealias Block = (_ result : String) ->()
    
    var isReading : Bool!
    
    var line : UIImageView!//扫描线
    
    var captureSession : AVCaptureSession?//捕捉会话
    
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?//展示layer
    
    var cropLayer : CAShapeLayer!
    
    var timer : Timer!//定时器
    
    var upOrdown : Bool = false
    
    var num : Int = 0
    
    var myblock:Block!
    
    deinit {
        captureSession = nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initNav()
        initScanpreView()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setCropRect(cropRect: kScanRect)
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            DispatchQueue.main.async {
                if (granted) {
                    self.loadScanView()
                }else{
                    LHHUBViewController().alertView(VC: self, title: "请在iPhone的“设置-隐私-相机”选项中，允许App访问你的相机", message: "", block: { (index) in
                        
                    })
                }
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        stopRunning()
    }
    
    func initNav() {
        self.navigationController?.title = "扫一扫"
    }
    
    func initScanpreView() {
        let imageView : UIImageView = UIImageView.init(frame: kScanRect)
        imageView.image = UIImage.init(named: "pick_bg")
        self.view.addSubview(imageView)
        
        line = UIImageView.init(frame: CGRect.init(x: LEFT, y: TOP+10, width: 220, height: 2))
        line.image = UIImage.init(named: "line")
        self.view.addSubview(line)
        
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(moveUpAndDownLine), userInfo: nil, repeats: true)
    }
    
    func setCropRect(cropRect : CGRect) {
        cropLayer = CAShapeLayer.init()
        let path : CGMutablePath = CGMutablePath()
        path.addRect(cropRect)
        path.addRect(self.view.bounds)
        
        cropLayer.fillRule = kCAFillRuleEvenOdd
        cropLayer.path = path
        cropLayer.fillColor = UIColor.black.cgColor
        cropLayer.opacity = 0.6
        cropLayer.setNeedsDisplay()
        
        self.view.layer.addSublayer(cropLayer!)
    }
    
   func loadScanView() {
        //Device
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        //inut
        do {
            let input = try AVCaptureDeviceInput(device:device!)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
        } catch {
            print(error)
            return
        }
        //output
        let output = AVCaptureMetadataOutput()
        output.rectOfInterest = CGRect.init(x: TOP/SCREEN_HEIGHT, y: LEFT/SCREEN_WIDTH, width: 220/SCREEN_HEIGHT, height: 220/SCREEN_WIDTH)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        //Session
        captureSession?.sessionPreset = AVCaptureSession.Preset.high
        captureSession?.addOutput(output)
        output.metadataObjectTypes = [
            AVMetadataObject.ObjectType.qr,
            AVMetadataObject.ObjectType.code39,
            AVMetadataObject.ObjectType.code128,
            AVMetadataObject.ObjectType.code39Mod43,
            AVMetadataObject.ObjectType.ean13,
            AVMetadataObject.ObjectType.ean8,
            AVMetadataObject.ObjectType.code93]
        //Preview
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = self.view.layer.bounds
    self.view.layer.insertSublayer(videoPreviewLayer!, at: 0)
        
        startRunning()
    }
    
    //MARK:- 开始
    func startRunning() {
        if (captureSession != nil) {
            isReading = true
            captureSession?.startRunning()
        }
    }
    
    //MARK:- 结束
    func stopRunning() {
        if captureSession != nil && timer != nil {
            captureSession?.stopRunning()
            timer.fireDate = Date.distantFuture
        }
    }
    
    @objc func moveUpAndDownLine() {
        if (upOrdown == false) {
            num  = num + 1
            line.frame = CGRect.init(x: LEFT, y: TOP + 10 + (CGFloat)(2*num), width: 220, height: 2)
            if (2*num == 200) {
                upOrdown = true
            }
        }
        else {
            num = num - 1
            line.frame = CGRect.init(x: LEFT, y: TOP + 10 + (CGFloat)(2*num), width: 220, height: 2)
            if (num == 0) {
                upOrdown = false
            }
        }
    }
    
    //MARK:- AVCaptureMetadataOutputObjectsDelegate
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if !isReading {
            return
        }
        stopRunning()
        let metadataObject : AVMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        let result : String  = metadataObject.stringValue!
        LHHUBViewController().alertView(VC: self, title: "温馨提示", message: result, block: { (index) in
            self.startRunning()
            self.timer.fireDate = Date()
        })
//        if let _ = myblock {
//            self.myblock(result);
//        }
//        self.navigationController?.popViewController(animated: true)
    }
    
}
