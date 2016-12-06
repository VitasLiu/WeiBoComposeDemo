//
//  WBEmotionKeyboardCell.swift
//  WeiBo
//
//  Created by Vitas on 2016/12/5.
//  Copyright © 2016年 Vitas. All rights reserved.
//

import UIKit

private let baseTag = 66

class WBEmotionKeyboardCell: UICollectionViewCell {
    
    var emotions: [WBEmotionModel]? {
        didSet {
            // 在cell中的21个图标, 除了删除按钮,其它下标为0到19的图标先隐藏起来
            for i in 0..<20 {
                let tag = i + baseTag
                // 通过tag(标签)获取到当前对象所有的子控件
                let button = self.viewWithTag(tag)
                button?.isHidden = true
            }
            // 遍历传递过来的emotions数组
            if let emotions = emotions {
                for item in emotions.enumerated() {
                    let index = item.offset
                    let model = item.element
                    // 显示emotions数组的长度所有的图标
                    let button = self.viewWithTag(index + baseTag) as! UIButton
                    button.isHidden = false
                    // 判断表情类型, 如果为emoji表情
                    if model.type == 1 {
                        // model.code : emoji的16进制的字符串
                        // 将十六进制的编码转为emoji字符
                        let emoji = NSString.emoji(withStringCode: model.code)
                        // 设置按钮的文字, 颜色, 图片为nil, 图像大小为文字字体的大小
                        button.setTitle(emoji, for: .normal)
                        button.setTitleColor(UIColor.red, for: .normal)
                        button.setImage(nil, for: .normal)
                        button.titleLabel?.font = UIFont.systemFont(ofSize: 34)
                    } else {
                        // 如果为图片表情, 根据model.fullPath 图片的全路径, 设置按钮图像
                        // 然后按钮文字为nil, 为了cell复用, 记得设置更新所有的因素
                        button.setImage(UIImage(named: model.fullPath!), for: .normal)
                        button.setTitle(nil, for: .normal)
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WBEmotionKeyboardCell {
    func setupUI () {
        
        backgroundColor = UIColor.white
        
        // button的宽
        let buttonWidth = (screenWidth)/7
        // 第一个button的rect
        let rect = CGRect(x: 0, y: 10, width: buttonWidth, height: buttonWidth)
        // 添加9个子视图
        for i in 0..<21 {
            // 行数
            let row = i / 7
            // 列数
            let col = i % 7
            // 算出每个button的rect
            // rect.offsetBy(dx:, dy:) 这个方法是一个rect为参照物, 在x和y轴上偏移, 从而获得新的rect
            let buttonRect = rect.offsetBy(dx: buttonWidth*CGFloat(col), dy: ((buttonWidth + 10)*CGFloat(row)))
            
            // 创建并添加按钮
            let button = UIButton(frame: buttonRect)
            // 设置每个按钮的标签(tag), 方便在其它地方获取这些不同的按钮, 同时不用创建一个数组来存放这些数组, 占用更小的内存
            // 标签为什么要加上baseTag(66)这样的值呢. 因为tag默认为0, 如果不设置的话, 所有的视图的标签值都为0, 当获取tag=0的按钮时, 获取不到正确的值(因为可能有其它没有设置tag值的控件, 会发生冲突)
            button.tag = baseTag + i
            
            addSubview(button)
            
            // 如果按钮是删除按钮
            if i == 20 {
                button.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
                button.setImage(UIImage(named: "compose_emotion_delete_highlighted"), for: .highlighted)
            }
            
            //添加点击事件
            button.addTarget(self, action: #selector(addOrDeleteEmotion(button:)), for: .touchUpInside)
        }
    }
}

extension WBEmotionKeyboardCell {
    // 插入或者删除图标
    // 1.先通过按钮的监听事件, 传递按钮button
    // 2.然后通过按钮的tag获取到对应的emotion 模型对象 和 判断是否是删除按钮
    // 3.通过广播的方式把emotion和是否删除按钮的判断传递出去
    // 4.因为现在这个方法是在cell的内部, 而需要联动的textView是在controller上添加的. 
    //   控制器把model对象从cell传递到要显示的textView上, 控制器起桥梁的作用.
    @objc fileprivate func addOrDeleteEmotion(button: UIButton)  {
        var isDelete: Bool = false
        var userInfo: [String: Any] = [:]
        if button.tag - baseTag == 20 {
            isDelete = true
            userInfo = ["isDelete": isDelete]
        } else {
            isDelete = false
            let emotion = emotions![button.tag - baseTag]
            userInfo = ["isDelete": isDelete, "emotion": emotion]
        }
        
        let notification = Notification(name: addOrDeleteNotification, object: nil, userInfo: userInfo)
        NotificationCenter.default.post(notification)
    }
    
}
