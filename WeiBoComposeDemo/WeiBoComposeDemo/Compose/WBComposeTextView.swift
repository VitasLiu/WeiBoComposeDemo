//
//  WBComposeTextView.swift
//  WeiBo
//
//  Created by Vitas on 2016/12/3.
//  Copyright © 2016年 Vitas. All rights reserved.
//

import UIKit

class WBComposeTextView: UITextView {

    var placeHolder: String? = "Say something from your heart" {
        didSet {
            placeHolderLabel.text = placeHolder
        }
    }
    
    override var font: UIFont? {
        didSet {
            placeHolderLabel.font = font
        }
    }
    
    lazy var placeHolderLabel: UILabel = UILabel(title: self.placeHolder, fontSize: 13)
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: Notification.Name.UITextViewTextDidChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - 设置UI
extension WBComposeTextView {
    func setupUI() {
        // 要设置textView的字体大小, 方便自己在一个方法里修改富文本attributedText的字体大小, 设置表情的大小
        self.font = UIFont.systemFont(ofSize: 14)
        
        //垂直方向的回弹效果
        self.alwaysBounceVertical = true
        //滑动收起键盘
        self.keyboardDismissMode = .onDrag
        self.backgroundColor = UIColor.white
        addSubview(placeHolderLabel)
        
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(8)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
        }
    }
}

// MARK: - 通知事件处理
extension WBComposeTextView {
    func textDidChange() {
        placeHolderLabel.isHidden = text.characters.count > 0
    }
}

// MARK: - 功能扩展, 表情文字字符串
extension WBComposeTextView {
    func insertEmotion (emotion: WBEmotionModel) {
        //emoji表情
        if emotion.type == 1 {
            let emoji = NSString.emoji(withStringCode: emotion.code)
            self.insertText(emoji!)
            return
        }
        
        //图片表情
        //1. 生成一个图片的附件, Attachment:附件
        let attachMent = NSTextAttachment()
        
        //2. 使用NSTextAttachment将想要插入的图片作为一个字符处理，转换成NSAttributedString
        attachMent.image = UIImage(named: emotion.fullPath!)
        
        //3. 因为图片的大小是按照原图的尺寸, 所以要设置图片的bounds, 也就是大小
        attachMent.bounds = CGRect(x: 0, y: -4, width: font!.lineHeight, height: font!.lineHeight)
        
        //4. 将图片添加到富文本上
        let attachString = NSAttributedString(attachment: attachMent)
        
        //5. 把图片富文本转换成可变的富文本
        let mutiAttachString = NSMutableAttributedString(attributedString: attachString)
        
        //6. 调用富文本的对象方法 addAttributes(_ attrs: [String : Any] = [:], range: NSRange)
        //来修改对应range范围中 attribute属性的 value值
        //这里是修改富文本所有文本的字体大小为textView里的文本大小
        mutiAttachString.addAttributes([NSFontAttributeName: font!], range: NSMakeRange(0, attachString.length))
        
        // selectedRange  textView的选中范围
        var range = selectedRange
        
        // attributedText textView的富文本属性
        let attriText = attributedText.copy()
        
        // 把当前textView里的富文本变成可变的富文本
        let mutiAttriText = NSMutableAttributedString(attributedString: attriText as! NSAttributedString)
        
        // 替换所选的范围(当前textView里已有的富文本替换刚插入的图片富文本)
        mutiAttriText.replaceCharacters(in: range, with: attachString)
        
        // 修改textView富文本对应范围内的字体(针对新插入的图片富文本和原来的富文本)
        mutiAttriText.addAttributes([NSFontAttributeName: font!], range: NSMakeRange(0, mutiAttriText.length))
        
        // 设置新的textView富文本
        attributedText = mutiAttriText
        
        // 光标后移一位(不管在任何位置插入一个, 或者替换图片富文本, 光标所在位置后移一位)
        range.location += 1
        
        // 没有选择任何内容
        range.length = 0
        
        // 更新当前所在的光标位置
        selectedRange = range
        
        // 因为这是我们自己拓展的一个方法, 自己在textView的内部做文字发生变化的操作
        // 系统不会帮我们自己发送文本长度发生了变化的通知, 需要我们自己去发通知
        // 发通知,通知文本的长度发生了变化
        NotificationCenter.default.post(name: Notification.Name.UITextViewTextDidChange, object: nil)
        // 让发布按钮显示出来
        delegate?.textViewDidChange!(self)
    }
}




















































































