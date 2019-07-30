//
//  UIButton+Category.swift
//  LHTool
//
//  Created by 刘恒 on 2018/3/31.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

extension UIButton {
    
    ///
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - imageName: 图片
    ///   - target: AnyObject
    ///   - selectro: 点击事件
    ///   - font: 字体大小
    ///   - titleColor: 字体颜色
    convenience  init(title: String?, imageName: String?, target: AnyObject?, selectro: Selector?, font: UIFont?, titleColor: UIColor?) {
        self.init()
        if let image = imageName {
                setImage(UIImage.init(named: image), for: .normal)
        }
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = font
        setTitle(title, for: .normal)
        if let sel = selectro {
            addTarget(target, action: sel, for: .touchUpInside)
        }
    }
}
