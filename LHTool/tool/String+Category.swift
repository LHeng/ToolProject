//
//  String+Category.swift
//  LHTool
//
//  Created by 刘恒 on 2018/4/2.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

extension String {
    
    /// 判断是否是手机号
    func isPhoneNumber() -> Bool {
        let pattern = "^1[345789]\\d{9}$"
        return NSPredicate.init(format:"SELF MATCHES %@",pattern).evaluate(with: self)
    }
    
    /// 判断是否是邮政编码
    func isPostCode() -> Bool {
        let pattern = "^\\d{6}$"
        return NSPredicate.init(format:"SELF MATCHES %@",pattern).evaluate(with: self)
    }
    
}
