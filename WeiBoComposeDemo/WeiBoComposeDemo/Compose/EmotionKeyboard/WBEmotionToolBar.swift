//
//  WBEmotionToolBar.swift
//  WeiBo
//
//  Created by Vitas on 2016/12/5.
//  Copyright © 2016年 Vitas. All rights reserved.
//

import UIKit

private let baseTag = 555

protocol WBEmotionToolBarDelegate: NSObjectProtocol {
    func changeEmotion(index: Int)
}

class WBEmotionToolBar: UIStackView {
    
    weak var delegate: WBEmotionToolBarDelegate?
    
    var index: Int = 0 {
        didSet {
            let tag = index + baseTag
            selectedButton?.isSelected = false
            let button = self.viewWithTag(tag) as! UIButton
            selectedButton = button
            selectedButton?.isSelected = true
        }
    }
    
    var selectedButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal //水平还是垂直布局
        distribution = .fillEqually //等距填充
        
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

@available(iOS 9.0, *)
extension WBEmotionToolBar {
    func setupUI() {
        let buttonDictArray = [["title": "最近", "bgImage": "compose_emotion_table_left"],
                               ["title": "默认", "bgImage": "compose_emotion_table_mid"],
                               ["title": "emoji", "bgImage": "compose_emotion_table_mid"],
                               ["title": "浪小花", "bgImage": "compose_emotion_table_right"]]
        
        for item in buttonDictArray.enumerated() {
            let index = item.offset
            let dict = item.element
            let button = UIButton()
            let bgImage = dict["bgImage"]!
            let title = dict["title"]!
            button.setBackgroundImage(UIImage(named: bgImage), for: .normal)
            button.setBackgroundImage(UIImage(named: "\(bgImage)_selected"), for: .selected)
            button.setTitle(title, for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.setTitleColor(UIColor.black, for: .selected)
            button.addTarget(self, action: #selector(changeEmotion (button:)), for: .touchUpInside)
            button.tag = index + baseTag
            addArrangedSubview(button)
            
            if index == 0 {
                button.isSelected = true
                selectedButton = button
            }
        }
    }
}

extension WBEmotionToolBar {
    @objc fileprivate func changeEmotion (button: UIButton) {
        selectedButton?.isSelected = false
        selectedButton = button
        selectedButton?.isSelected = true
        
        delegate?.changeEmotion(index: button.tag - baseTag)
    }
}
