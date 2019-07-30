//
//  Prompt.swift
//  LHTool
//
//  Created by 刘恒 on 2018/6/14.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

typealias Block = (_ type : Int ) -> ()

class LHHUBViewController: NSObject {
    
    /// 提示弹框
    ///
    /// - Parameters:
    ///   - VC: 显示的视图
    ///   - title: 主题
    ///   - message: 信息
    ///   - block: 按钮回调
    func alertView(VC: UIViewController, title: String?, message: String?, block: Block?)  {
        let alertVC : UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction.init(title: "确认", style: .default) { (action) in
            if  let _ = block {
                block!(0)
            }
            alertVC.dismiss(animated: true, completion: nil)
        }
        let action2 = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(action1)
        alertVC.addAction(action2)
        VC.present(alertVC, animated: true, completion: nil)
    }
    
    
    /// 选择图片
    ///
    /// - Parameters:
    ///   - VC: 显示的视图
    ///   - title: 主题
    ///   - message: 信息
    ///   - action: 动作事件
    ///   - block: 按钮回调
    func actionSheetView(vc: UIViewController, title: String?, message: String?, action: [String], block: Block?)  {
        let alertVC : UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        
        for i in 0..<action.count {
            let action = UIAlertAction.init(title: action[i], style: .default) { (action) in
                if  let _ = block {
                    block!(i)
                }
                alertVC.dismiss(animated: true, completion: nil)
            }
            alertVC.addAction(action)
        }
        let action = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(action)
        vc.present(alertVC, animated: true, completion: nil)
    }
}

