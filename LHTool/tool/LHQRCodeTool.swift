//
//  LHQRCodeTool.swift
//  LHTool
//
//  Created by 刘恒 on 2018/7/13.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

class LHQRCodeTool: NSObject {

    //MARK: -传进去字符串,生成二维码图片
    func createQRCode(data: String, imageViewWidth: CGFloat) -> UIImage {
        
        //创建滤镜对象
        let filter : CIFilter = CIFilter.init(name: "CIQRCodeGenerator")!
        
        //回复滤镜对象的默认属性
        filter.setDefaults()
        
        //设置属性
        //将字符串转化为Data类型
        let infoData = data.data(using: .utf8)
        
        //通过KVC设置滤镜inputMessage数据
        filter.setValue(infoData, forKey: "inputMessage")
        
        //获取滤镜输出的图像
        let outputImage : CIImage = filter.outputImage!
        
        return createNonInterpolateUIImageFormCIImage(image: outputImage, size: imageViewWidth)
    }
    
    //MARK: - 根据背景图片和头像合成头像二维码
    
    func creatImage(bgImage: UIImage, iconImage: UIImage) -> UIImage{
        
        //开启图片上下文
        UIGraphicsBeginImageContext(bgImage.size)
        
        //绘制背景图片
        bgImage.draw(in: CGRect(origin: CGPoint.zero, size: bgImage.size))
        
        //绘制头像
        let width: CGFloat = 50
        
        let height: CGFloat = width
        
        let x = (bgImage.size.width - width) * 0.5
        
        let y = (bgImage.size.height - height) * 0.5
        
        iconImage.draw(in: CGRect(x: x, y: y, width: width, height: height))
        
        //取出绘制好的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //关闭上下文
        UIGraphicsEndImageContext()
        //返回合成好的图片
        
        return newImage!
    }
    
    //MARK: - 根据CIImage生成指定大小的高清UIImage
    func createNonInterpolateUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent = image.extent
        
        let scale: CGFloat = min(size/extent.width, size/extent.height)
        
        let width = extent.width * scale
        
        let height = extent.height * scale
        
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.init(rawValue: CGInterpolationQuality.none.rawValue)!
        
        bitmapRef.scaleBy(x: scale, y: scale)
        
        bitmapRef.draw(bitmapImage, in: extent)
      
        let newImage = bitmapRef.makeImage()
        
        return UIImage.init(cgImage: newImage!)
    }
}
