//
//  DispatchQueue+Category.swift
//  LHTool
//
//  Created by 刘恒 on 2018/8/28.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

extension DispatchQueue {

    private static var _onceTracker = [String]()
    public class func once(token: String, block: () -> ()) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
    
    func async(block: @escaping ()->()) {
       async(execute: block)
    }
    
    func after(time: DispatchTime, block: @escaping ()->()) {
        asyncAfter(deadline: time, execute: block)
    }
}
