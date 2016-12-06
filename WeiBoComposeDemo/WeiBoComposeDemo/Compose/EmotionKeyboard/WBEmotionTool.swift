//
//  WBEmotionTool.swift
//  WeiBo
//
//  Created by Vitas on 2016/12/6.
//  Copyright © 2016年 Vitas. All rights reserved.
//

import UIKit

class WBEmotionTool: NSObject {
    static let shared: WBEmotionTool = WBEmotionTool()
    
    /// 最终的dataSource的数组
    var dataSourceArray: [[[WBEmotionModel]]] {
        let defalut = divideEmotions(emotions: parseEmotionModel(path: defaultPath))
        let emoji = divideEmotions(emotions: parseEmotionModel(path: emojiPath))
        let lxh = divideEmotions(emotions: parseEmotionModel(path: lxhPath))
        
        return [defalut, defalut, emoji, lxh]
    }
    
    /// 表情bundle的地址
    var bundlePath: String {
        return Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil)!
    }
    /// 默认表情的地址
    var defaultPath: String {
        //return (bundlePath as NSString).appendingPathExtension("")
        return bundlePath + "/Contents/Resources/default/info.plist"
    }
    
    /// emoji表情的地址
    var emojiPath: String {
        //return (bundlePath as NSString).appendingPathExtension("")
        return bundlePath + "/Contents/Resources/emoji/info.plist"
    }
    
    /// lxh表情的地址
    var lxhPath: String {
        //return (bundlePath as NSString).appendingPathExtension("")
        return bundlePath + "/Contents/Resources/lxh/info.plist"
    }
    
    /// 根据path解析出表情的model
    func parseEmotionModel(path: String) -> [WBEmotionModel] {
        /// 定义一个空数组
        var emotionMeodels = [WBEmotionModel]()
        if let emotionDicArray = NSArray.init(contentsOfFile: path) as? [[String: Any]] {
            for dict in emotionDicArray {
                let model = WBEmotionModel(dict: dict)
                if model.type == 0 {
                    let folderPath = (path as NSString).deletingLastPathComponent
                    model.fullPath = "\(folderPath)/\(model.png!)"
                }
                emotionMeodels.append(model)
            }
        }
        
        return emotionMeodels
    }
    
    /// 将表情model根据cell来分组
    func divideEmotions(emotions: [WBEmotionModel]) -> [[WBEmotionModel]] {
        //算出需要分几组
        var devidedArray: [[WBEmotionModel]] = []
        let count = (emotions.count - 1)/20 + 1
        
        for i in 0..<count {
            
            let location = i * 20
            var length = 20
            //如果剩下的表情不到二十个, 则是最后一组, 有多少个, 显示多少个
            if emotions.count - location < 20 {
                length = emotions.count - location
            }
            
            let range = NSMakeRange(location, length)
            //用range取array元素
            let cellEmotions = (emotions as NSArray).subarray(with: range)
            devidedArray.append(cellEmotions as! [WBEmotionModel])
        }
        
        return devidedArray
    }
}
