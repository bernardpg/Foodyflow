//
//  Refrige.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/19/22.
//

import Foundation

struct Refrige: Codable {
    
    var id: String
    var title: String
    var foodID: [String]
    var createdTime: Int64
    var category: String
    var shoppingList: [String]
//    var author: Author?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case foodID
        case createdTime
        case category = "tag"
        case shoppingList
//        case author
    }
    
    var toDict: [String: Any] {
        return [
            "id": id as Any,
            "title": title as Any,
            "foodID": foodID as Any,
            "createdTime": createdTime as Any,
            "tag": category as Any,
            "shoppingList": shoppingList as Any
 //           "author": author?.toDict
        ]
    }
}
