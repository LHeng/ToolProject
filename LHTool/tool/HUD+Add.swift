//
//  HUD+Add.swift
//  LHTool
//
//  Created by 刘恒 on 2018/7/6.
//  Copyright © 2018年 LH. All rights reserved.
//

import Foundation

extension MBProgressHUD  {
    
    /// 显示信息
    ///
    /// - Parameters:
    ///   - text: 信息内容
    ///   - icon: 图片
    ///   - vc: 显示的视图
    func show(text: String, icon:String, vc: UIView) {
        //快速显示一个提示框
        let hud : MBProgressHUD = MBProgressHUD.showAdded(to: vc, animated: true)
        hud.label.text = text
        //设置图片
        hud.customView = UIImageView.init(image: UIImage.init(named: String.init(format: "MBProgressHUD.bundle/%@", icon)))
        //设置模式
        hud.mode = .customView
        //隐藏时从父控件移除
        hud.removeFromSuperViewOnHide = true
        
        //1秒之后消失
        hud.hide(animated: true, afterDelay: 1.0)
    }
    
    
    /// 显示成功信息
    ///
    /// - Parameter success: 信息内容
    func showSuccess(success: String) {
        MBProgressHUD().hideHUD()
        self.showSuccess(success: success, vc: UIApplication.shared.windows.last!)
    }
    
    
    /// 显示成功信息
    ///
    /// - Parameters:
    ///   - success: 信息内容
    ///   - vc: 显示信息的视图
    func showSuccess(success: String, vc: UIView) {
        MBProgressHUD().hideHUD()
        self.show(text: success, icon: "", vc: vc)
    }
    
    
    /// 显示错误信息
    ///
    /// - Parameter error: 信息内容
    func showError(error: String) {
        MBProgressHUD().hideHUD()
        self.showErrpr(error: error, vc: UIApplication.shared.windows.last!)
    }
    
    /// 显示错误信息
    ///
    /// - Parameters:
    ///   - success: 信息内容
    ///   - vc: 显示信息的视图
    func showErrpr(error: String, vc: UIView) {
        MBProgressHUD().hideHUD()
        self.show(text: error, icon: "", vc: vc)
    }
    
    /// 显示错误信息
    ///
    /// - Parameter message: 信息内容
    /// - Returns: 直接返回一个MBProgressHUD，需要手动关闭
    func showMessage(message: String) -> MBProgressHUD {
        MBProgressHUD().hideHUD()
        return showMessage(message: message, view: UIApplication.shared.windows.last!)
    }
    
    /// 显示一些信息
    ///
    /// - Parameters:
    ///   - message: 信息内容
    ///   - view: 需要显示信息的视图
    /// - Returns: 直接返回一个MBProgressHUD，需要手动关闭
    func showMessage(message: String,view: UIView) -> MBProgressHUD! {
        // 快速显示一个提示信息
        let hud : MBProgressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = message;
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = true;
        // YES代表需要蒙版效果
        hud.backgroundColor  = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        return hud;
    }
    
    /// 手动关闭MBProgressHUD
    func hideHUD() {
        let view = UIApplication.shared.windows.last!
        MBProgressHUD().hideHUDForView(vc: view)
    }
    
    /// 手动关闭MBProgressHUD
    ///
    /// - Parameter vc: 显示MBProgressHUD的视图
    func hideHUDForView(vc: UIView) {
        MBProgressHUD.hide(for: vc, animated: true);
    }
}


