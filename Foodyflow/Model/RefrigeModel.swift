//
//  RefrigeModel.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/17/22.
//

import Foundation

struct Model {
    
    var id: String
    var text: String
    var foodID: [FoodInfo]
    init(id: String ,text: String,foodID: [FoodInfo]) {
        self.id = id
        self.text = text
        self.foodID = foodID
    }
}

struct Article: Codable {
    
    var id: String
    var title: String
    var content: String
    var createdTime: Int64
    var category: String
//    var author: Author?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case createdTime
        case category = "tag"
//        case author
    }
    
    var toDict: [String: Any] {
        return [
            "id": id as Any,
            "title": title as Any,
            "content": content as Any,
            "createdTime": createdTime as Any,
            "tag": category as Any,
 //           "author": author?.toDict
        ]
    }
}
