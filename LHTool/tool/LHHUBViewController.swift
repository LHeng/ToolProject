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
    func alertView(VC:UIViewController,title:String,message:String,block: Block?)  {
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
    ///   - block: 按钮回调
    func actionSheetView(VC:UIViewController,title:String,message:String,block: Block?)  {
        let alertVC : UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction.init(title: "拍照", style: .default) { (action) in
            if  let _ = block {
                block!(1)
            }
            alertVC.dismiss(animated: true, completion: nil)
        }
        let action2 = UIAlertAction.init(title: "手机相册", style: .default) { (action) in
            if  let _ = block {
                block!(2)
            }
            alertVC.dismiss(animated: true, completion: nil)
        }
        let action3 = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(action1)
        alertVC.addAction(action2)
        alertVC.addAction(action3)
        VC.present(alertVC, animated: true, completion: nil)
    }
    
}
