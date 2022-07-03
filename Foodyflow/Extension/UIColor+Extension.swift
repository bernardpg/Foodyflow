//
//  UIColor+Extension.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/16/22.
//

import Foundation
import UIKit

extension UIColor {
    
    static func hexStringToUIColor(hex: String) -> UIColor {

        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    struct FoodyFlow {
        
        static var darkOrange: UIColor { return UIColor(red: 244/255, green: 148/255, blue: 58/255, alpha: 1) }

        static var lightOrange: UIColor { return UIColor(red: 252/255, green: 227/255, blue: 203/255, alpha: 1) }

        static var extraOrange: UIColor { return UIColor(red: 255/255, green: 246/255, blue: 237/255, alpha: 1) }

        static var white: UIColor { return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1) }

        static var lightGray: UIColor { return UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1) }

        static var darkGray: UIColor { return UIColor(red: 141/255, green: 141/255, blue: 141/255, alpha: 1) }

        static var black: UIColor { return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1) }
    }
}
