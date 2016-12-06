//
//  UIButton+extension.swift
//  WeiBo
//
//  Created by Vitas on 2016/11/24.
//  Copyright © 2016年 Vitas. All rights reserved.
//

import UIKit
//swift3.0的特点: 在方法中, 介词(in, at, of, with, to)的部分变成了参数的一部
//在写便利构造器的时候,必须至少有一个参数, 不能设默值
//如果所有参数都有默认值, 意味着所有参数都可以不传,就会和 init()方法冲突

extension UIButton {
    convenience init (title: String?, fontSize: CGFloat = 13, color: UIColor = UIColor.darkGray, image: String? = nil, bgImage: String? = nil, target: Any? = nil, selector: Selector? = nil, event: UIControlEvents = .touchUpInside) {
        
        self.init()
        
        // 设置title
        if let title = title {
            
            self.setTitle(title, for: .normal)
            self.setTitleColor(color, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        }
        
        // 设置图片
        if let image = image {
            self.setImage(UIImage(named: image), for: .normal)
            self.setImage(UIImage(named: "\(image)_highlighted"), for: .highlighted)
        }
        
        // 设置背景图片
        if let bgImage = bgImage {
            self.setBackgroundImage(UIImage(named: bgImage), for: .normal)
            self.setBackgroundImage(UIImage(named: "\(bgImage)_highlighted"), for: .highlighted)
        }
        
        // 给button加点击事件
        if let target = target, let selector = selector {
            self.addTarget(target, action: selector, for: event)
        }
    }
}
