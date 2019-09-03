//
//  ViewController.swift
//  LHTool
//
//  Created by 刘恒 on 2018/3/31.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

class LHViewController: UIViewController {
    
    @IBOutlet weak var imageQRCode: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LHCheckVersion.share().isUpdataApp()
        imageQRCode.isHidden = true
        let touch = UITapGestureRecognizer.init(target: self, action: #selector(touchEvent))
        view.addGestureRecognizer(touch)
    }

    private func post() {

        let url = "http://zhanhui-background.phhyzy.com/robot/health/message"
        var param: [String : Any] = [String : Any]()
        param["dataType"] = "bp-msg"
        param["elderCode"] = "OR63854292373"
        param["param"] = "{\"devId\": \"00084bd7\",\"occurTime\": 1547100617645,\"devType\": \"InfraThermo\",\"measureMode\": \"\",\"temperature\": 36.7,\"unit\":\"℃\"}"

        LHRequseTool.requestPost(url: url, params: param as NSDictionary , dataArr: NSMutableArray(), success: { (respones) in
                
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
//        MBProgressHUD().showError(error: "失败了")
        let vc = TabBarViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func showSuccess(_ sender: Any) {
        post()
        MBProgressHUD().showSuccess(success: "成功了")
        let vc = SDKDemoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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


