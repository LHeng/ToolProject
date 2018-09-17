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
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        if ((regextestmobile.evaluate(with: self) == true)
            || (regextestcm.evaluate(with: self)  == true)
            || (regextestct.evaluate(with: self) == true)
            || (regextestcu.evaluate(with: self) == true))
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    /// 判断是否是邮政编码
    func isPostCode() -> Bool {
        let pattern = "^\\d{6}$"
        return NSPredicate.init(format:"SELF MATCHES %@",pattern).evaluate(with: self)
    }
    
    
    ///判断是否为网页地址
    func isUrl()->Bool {
        let strArr = self.components(separatedBy: ":")
        return strArr.count > 1 ? true : false
    }
    
    ///判断字符串是否为空
    func isNotEmpty()->Bool{
        return self.count > 0 ? true : false
    }
    
    //检验密码是否符合6-20位的要求
    func isPassword()->Bool{
        let regex = "{6,20}"
        let passwordTest = NSPredicate.init(format: "SELF MATCHES\(regex)")
        return passwordTest.evaluate(with: self)
    }

    static func telAndPasswordIsRight(telNum : String,password : String)->Bool{
        if telNum.isPhoneNumber() && password.isPassword() {
            return true
        }else{
            return false
        }
    }
    
    func getNumberFomat()->Double {
        let nonDigits = NSCharacterSet.decimalDigits.inverted
        let remainSecond : NSString = self.trimmingCharacters(in: nonDigits) as NSString
        return remainSecond.doubleValue
    }
}
