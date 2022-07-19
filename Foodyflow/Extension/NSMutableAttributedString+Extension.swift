//
//  NSMutableAttributedString+Extension.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 7/14/22.
//

import UIKit

extension NSMutableAttributedString {
    
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
}
