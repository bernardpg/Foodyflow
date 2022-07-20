//
//  CategoryHelper.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 7/20/22.
//

import Foundation

enum CategoryType: Int, CaseIterable, CustomStringConvertible, RawRepresentable {
    
    case meat, beans, eggs, vegs, pickles, fruit, fishes, seafoods, beverage, seasons, others
    
    var description: String {
    switch self {
    case .meat : return  "肉類"
    case .beans : return "豆類"
    case .eggs : return "雞蛋類"
    case .vegs : return "青菜類"
    case .pickles : return "醃製類"
    case .fruit : return "水果類"
    case .fishes : return "魚類"
    case .seafoods : return "海鮮類"
    case .beverage: return "飲料類"
    case .seasons: return "調味料類"
    case .others: return "其他類"
        }
    }
    
    
}
