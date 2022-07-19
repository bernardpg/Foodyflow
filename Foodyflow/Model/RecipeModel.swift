//
//  RecipeModel.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 7/1/22.
//

import Foundation

struct Recipe: Codable {
    
    var recipeID: String
    
    var recipeName: String
    
    var recipeImage: String
    
    var recipeFood: String
    
    var recipeStep: String
    
    var recipeUserName: String
    
    var recipeUserID: String
    
 //   var isLike: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case recipeID
        case recipeName
        case recipeImage
        case recipeFood
        case recipeStep
        case recipeUserName
        case recipeUserID
//        case isLike
    }
    
    var toDict: [String: Any] {
        return [
            "recipeID": recipeID as Any,
            "recipeName": recipeName as Any,
            "recipeImage": recipeImage as Any,
            "recipeFood": recipeFood as Any,
            "recipeStep": recipeStep as Any,
            "recipeUserName": recipeUserName as Any,
            "recipeUserID": recipeUserID as Any
//            "isLike": isLike as Any
        ]
    }

}
