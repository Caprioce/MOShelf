//
//  NormalExtension.swift
//  Hupu
//
//  Created by 张驰 on 2018/6/26.
//  Copyright © 2018年 张驰. All rights reserved.
//

import UIKit

extension UIColor {
    class func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
