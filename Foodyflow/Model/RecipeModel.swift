//
//  RecipeModel.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 7/1/22.
//

import Foundation


struct Recipe: Codable {
    
    var userID: String
    
    var userName: String
    
    var userEmail: String
    
    var userPhoto: String
    
    var signInType: String
    
    var personalRefrige: [String?]
    
    var personalLikeRecipe: [String?]
    
    var personalDoRecipe: [String?]
        
}
