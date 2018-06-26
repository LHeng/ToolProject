//
//  UILabel+Category.swift
//  LHTool
//
//  Created by 刘恒 on 2018/3/31.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// 
    ///
    /// - Parameters:
    ///   - textColor: 字体颜色
    ///   - font: 字体大小
    convenience init(textColor: UIColor, font: UIFont) {
        self.init()
        self.font = font
        self.textColor = textColor
    }
}
