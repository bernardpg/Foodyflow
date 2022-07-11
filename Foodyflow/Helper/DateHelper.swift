//
//  DateHelper.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/18/22.
//

import Foundation

typealias CompletionHandler = ( [ String: Any ] ) -> Void

extension Date {
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    static var dateFormatter: DateFormatter {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
                
        return formatter
        
    }
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
            return (min(date1, date2) ... max(date1, date2)) ~= self
    }
    
}
