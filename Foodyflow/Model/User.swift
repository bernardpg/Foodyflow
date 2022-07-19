//
//  User.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/29/22.
//

import Foundation

struct UserInfo: Codable {
    
    var userID: String
    
    var userName: String
    
    var userEmail: String
    
    var userPhoto: String
    
    var signInType: String
    
    var personalRefrige: [String?]
    
    var personalLikeRecipe: [String?]
    
    var personalDoRecipe: [String?]
    
    var blockLists: [String?]
        
}

struct SignIn: Codable {
    
    var email: String
    
    var password: String
    
}

struct SignUp: Codable {

    var userName: String
    
    var userPhotoLink: String
    
    var email: String
    
    var password: String
    
}
