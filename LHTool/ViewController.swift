//
//  ViewController.swift
//  LHTool
//
//  Created by 刘恒 on 2018/3/31.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func date(_ sender: Any) {
//       let alert = LHPickerView.init(frame: self.view.bounds, type: .date)
//        alert.alpha = 0
//        UIApplication.shared.keyWindow?.addSubview(alert)
//        alert.dateblock = {(date) in
//            let select = date
//            let dateFormater = DateFormatter()
//            dateFormater.dateFormat = "yyyy-MM-dd"
//            let result = dateFormater.string(from: select)
//            print("---\(result)")
//        }
//        alert.showInView()
        MBProgressHUD().showSuccess(success: "你好呀")
    }
    @IBAction func sele(_ sender: Any) {
//        let alert = LHPickerView.init(frame: self.view.bounds, type: .selector)
//        alert.dataList = ["男","女"]
//        alert.alpha = 0
//        UIApplication.shared.keyWindow?.addSubview(alert)
//        alert.myblock = {(str) in
//            print("---\(str)")
//        }
//        alert.showInView()
        MBProgressHUD().showError(error: "我错了")
    }
    
    @IBAction func time(_ sender: Any) {
//        let alert = LHPickerView.init(frame: self.view.bounds, type: .time)
//        alert.alpha = 0
//        UIApplication.shared.keyWindow?.addSubview(alert)
//        alert.dateblock = {(date) in
//            let select = date
//            let dateFormater = DateFormatter()
//            dateFormater.dateFormat = "HH:mm:ss"
//            let result = dateFormater.string(from: select)
//            print("---\(result)")        }
//        alert.showInView()
        let HUD =  MBProgressHUD().showMessage( message: "我错了",view: view)
        
        let delaQueue = DispatchQueue.init(label: "com.syc.nd", qos: .userInteractive)
        let delayTime : DispatchTimeInterval = .seconds(5)
        delaQueue.asyncAfter(deadline: .now() + delayTime) {
            DispatchQueue.main.async(execute: {
                HUD?.hideHUDForView(vc: self.view)
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

