//
//  ShoppingList.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/17/22.
//

import Foundation

// create time

struct ShoppingList: Codable {
    
    var id: String
    var title: String
    var foodID: [String?]
//    var createdTime: Int64
//    var category: String
//    var author: Author?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case foodID
//        case createdTime
//        case category = "tag"
//        case author
    }
    
    var toDict: [String: Any] {
        return [
            "id": id as Any,
            "title": title as Any,
            "foodID": foodID as Any
//            "createdTime": createdTime as Any,
//            "tag": category as Any
 //           "author": author?.toDict
        ]
    }
}
