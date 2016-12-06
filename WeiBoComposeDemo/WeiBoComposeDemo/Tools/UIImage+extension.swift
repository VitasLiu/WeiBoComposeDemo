//
//  UIImage+extension.swift
//  WeiBo
//
//  Created by Vitas on 2016/11/30.
//  Copyright © 2016年 Vitas. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 绘制图像
    ///
    /// - Parameters:
    ///   - isCornored: 是否是圆角
    ///   - size: 绘制的大小
    ///   - backgroundColor: 背景颜色
    func wb_createImage(isCornored: Bool = true, size: CGSize = CGSize.zero, backgroundColor: UIColor = UIColor.white) -> UIImage {
        let rect = CGRect(origin: CGPoint.zero, size: size)
        // 1.开启上下文
        UIGraphicsBeginImageContext(size)
        
        // 2. 设置颜色
        backgroundColor.setFill()
        
        // 3. 颜色填充
        UIRectFill(rect)
        
        // 4. 切圆角, 添加裁切路径
        if isCornored {
            //切回角
            let path = UIBezierPath(ovalIn: rect)
            path.addClip()
        }
        
        // 5. 图像绘制
        self.draw(in: rect)
        
        // 6. 获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // 7.关闭上下文
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /// 绘制图像
    ///
    /// - Parameters:
    ///   - isCornored: 是否是圆角
    ///   - size: 绘制的大小
    ///   - backgroundColor: 背景颜色
    func wb_asyncCreateImage(isCornored: Bool = true, size: CGSize = CGSize.zero, backgroundColor: UIColor = UIColor.white, callBack: @escaping (_ image: UIImage)->()) {
        
        // 在子线程中处理图片
        DispatchQueue.global().async {
            let rect = CGRect(origin: CGPoint.zero, size: size)
            // 1.开启上下文
            UIGraphicsBeginImageContext(size)
            
            // 2. 设置颜色
            backgroundColor.setFill()
            
            // 3. 颜色填充
            UIRectFill(rect)
            
            // 4. 切圆角, 添加裁切路径
            let path = UIBezierPath(ovalIn: rect)
            path.addClip()
            
            // 5. 图像绘制
            self.draw(in: rect)
            
            // 6. 获取图片
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            // 7.关闭上下文
            UIGraphicsEndImageContext()
            
            // 在主线程回调图片
            DispatchQueue.main.async {
                callBack(image!)
            }
        }
        
    }
}




































