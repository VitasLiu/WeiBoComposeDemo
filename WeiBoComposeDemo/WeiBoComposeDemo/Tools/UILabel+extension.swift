//
//  UILabel+extension.swift
//  WeiBo
//
//  Created by Vitas on 2016/11/24.
//  Copyright © 2016年 Vitas. All rights reserved.
//

import UIKit

//便利构造器
//1. 必须使用convenience修饰
//2. 必须先调用指定构造器

//相当于oc中的category
extension UILabel {
    convenience init (title: String?, fontSize: CGFloat = 13, textColor: UIColor = UIColor.darkGray, alignMent: NSTextAlignment = .left, numOfLines: Int = 0) {
        //调用指定构造器,保存所有的存储属性被正确初始化
        self.init()
        //此时对象已创建
        self.text = title
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textColor = textColor
        self.textAlignment = alignMent
        self.numberOfLines = numOfLines
    }
}
