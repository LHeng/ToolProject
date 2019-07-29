//
//  ViewController.swift
//  LHTool
//
//  Created by 刘恒 on 2018/3/31.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageQRCode: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageQRCode.isHidden = true
        let touch = UITapGestureRecognizer.init(target: self, action: #selector(touchEvent))
        view.addGestureRecognizer(touch)
        post()
    }

    private func post() {

        var param: [String : Any] = [String : Any]()
        param["dataType"] = "bp-msg"
        param["elderCode"] = "OR63854292373"
        param["param"] = "{\"devId\": \"T0000085\", \"devType\": \"InfraThermo\", \"measureMode\": \"body\", \"occurTime\": 1563873687000, \"temperature\": 36,  \"unit\": \"℃\" }"

        LHRequseTool.requestPost(method: .RequestMethodPOST, params: param as NSDictionary , dataArr: NSMutableArray(), success: { (arr) in
                
        }) { (err) in

        }
    }
    
    @objc  func touchEvent() {
        imageQRCode.isHidden = true
    }
    
    @IBAction func date(_ sender: Any) {
        let alert = LHPickerView.init(frame: self.view.bounds, type: .date)
        alert.alpha = 0
        UIApplication.shared.keyWindow?.addSubview(alert)
        alert.dateblock = {(date) in
            let select = date
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "yyyy-MM-dd"
            let result = dateFormater.string(from: select)
            LHHUBViewController().alertView(VC: self, title: "温馨提示", message: result, block: { (index) in
                
            })
        }
        alert.showInView()
    }
    
    @IBAction func sele(_ sender: Any) {
        let alert = LHPickerView.init(frame: self.view.bounds, type: .selector)
        alert.dataList = ["男","女"]
        alert.alpha = 0
        UIApplication.shared.keyWindow?.addSubview(alert)
        alert.myblock = {(str) in
            LHHUBViewController().alertView(VC: self, title: "温馨提示", message: str, block: { (index) in
                
            })
        }
        alert.showInView()
    }
    
    @IBAction func time(_ sender: Any) {
        let alert = LHPickerView.init(frame: self.view.bounds, type: .time)
        alert.alpha = 0
        UIApplication.shared.keyWindow?.addSubview(alert)
        alert.dateblock = {(date) in
            let select = date
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "HH:mm:ss"
            let result = dateFormater.string(from: select)
            LHHUBViewController().alertView(VC: self, title: "温馨提示", message: result, block: { (index) in
                
            })
        }
        alert.showInView()
    }
    
    @IBAction func showError(_ sender: Any) {
        MBProgressHUD().showError(error: "失败了")
    }
    
    @IBAction func showSuccess(_ sender: Any) {
        MBProgressHUD().showSuccess(success: "成功了")
    }
    
    @IBAction func showMessge(_ sender: Any) {
        MBProgressHUD().show(text: "你该吃药了", icon: "", vc: view)
    }
    
    @IBAction func showLoading(_ sender: Any) {
        let HUD =  MBProgressHUD().showMessage( message: "加载中...",view: view)
        let delaQueue = DispatchQueue.init(label: "com.syc.nd", qos: .userInteractive)
        let delayTime : DispatchTimeInterval = .seconds(3)
        delaQueue.after(time: .now() + delayTime, block: {
            DispatchQueue.main.async(block: {
                HUD?.hideHUDForView(vc: self.view)
            })
        })
    }
    
    @IBAction func showQRCode(_ sender: Any) {
        imageQRCode.image = LHQRCodeTool().createQRCode(data: "你该吃药了", imageViewWidth: 200)
        imageQRCode.isHidden = false
    }
    
    @IBAction func scan(_ sender: Any) {
        let VC : LHScanVC = LHScanVC()
        VC.myblock = {(result)in
           
        }
        self.navigationController?.pushViewController(VC, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


