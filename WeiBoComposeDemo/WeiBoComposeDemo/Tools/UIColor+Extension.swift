//
//  UIColor+Extension.swift
//  WeiBo
//
//  Created by Vitas on 2016/12/3.
//  Copyright © 2016年 Vitas. All rights reserved.
//

import UIKit

enum UIColorHue : CGFloat {
    
    case redHue     = 0.0
    
    case orangeHue  = 30.0
    
    case yellowHue  = 60.0
    
    case greenHue   = 120.0
    
    case cyanHue    = 180.0
    
    case blueHue    = 240.0
    
    case magentaHue = 300.0
}

// MARK: - HSB related
extension  UIColor {
    
    /// Get a color of low saturation("soft") with given hue Value
    ///
    /// - Parameter hueValue: hue value 0.0...359.0
    /// - Returns: a color
    class func softColor(withHueValue hueValue: CGFloat) -> UIColor {
        return UIColor(hue: hueValue/359.0,
                       saturation: 0.37,
                       brightness: 0.88,
                       alpha: 1.0)
    }
    
    /// Get a color of low saturation("soft") with given hue Value
    ///
    /// - Parameter hue: an UIColorHue
    /// - Returns: a color
    class func softColor(withHue hue: UIColorHue) -> UIColor {
        return UIColor(hue: hue.rawValue/359.0,
                       saturation: 0.37,
                       brightness: 0.88,
                       alpha: 1.0)
    }
    
    /// Get a randomized color of low saturation("soft")
    ///
    /// - Returns: a random soft color
    class func randomSoftColor() -> UIColor {
        return UIColor.softColor(withHueValue: randomHueValue())
    }
}

// MARK: - RGB related
extension UIColor {
    
    /// Get a UIColor form HEX(ie.0xF29A2E)
    ///
    /// - Parameter fromHex: HEX
    /// - Returns: a color
    class func rgbColor(fromHex: Int) -> UIColor {
        
        let red     = CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
        let green   = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
        let blue    = CGFloat(fromHex & 0x0000FF) / 0xFF
        let alpha   = CGFloat(1.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// Get a randomized color with alpha of 1.0
    ///
    /// - Returns: a random color
    class func randomColor() -> UIColor {
        return UIColor(red: randomRGBColorValue(),
                       green: randomRGBColorValue(),
                       blue: randomRGBColorValue(),
                       alpha: 1.0)
    }
}

// MARK: - Helpers
fileprivate func randomRGBColorValue() -> CGFloat {
    return CGFloat(arc4random() % 256) / 255.0
}

fileprivate func randomHueValue() -> CGFloat {
    return CGFloat(arc4random() % 360)
}

