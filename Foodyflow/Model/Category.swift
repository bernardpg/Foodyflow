//
//  Category.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/20/22.
//

import Foundation

struct Category: Codable {
    
    var type: String?
    
    enum CodingKeys: String, CodingKey {
        case type
    }
    
    var toDict: [String: Any] {
        return [
            "type": type as Any,
        ]
    }
    
}
