//
//  Food.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/19/22.
//

import Foundation

struct FoodInfo: Codable {
    
    var foodId: String?
    
    var foodImages: String?
    
    var foodCategory: String?
    
    var foodName: String?
    
    var foodWeightAmount: Double?
    
    var foodWeightType: Int?
    
    var foodStatus: Int?
    
    var expireDate: Int64?
    
    var purchaseDate: Int64?
    
    var foodBrand: String?
    
    var priceTracker: Bool?
    
    var additional: String?
    
    var createdTime: Int64?
    
    enum CodingKeys: String, CodingKey {
        case foodId
        case foodImages
        case foodCategory
        case foodName
        case foodWeightAmount
        case foodWeightType
        case foodStatus
        case expireDate
        case purchaseDate
        case foodBrand
        case priceTracker
        case additional
        case createdTime
    }
    
    var toDict: [String: Any] {
        return [
            "foodId": foodId as Any,
            "foodImages": foodImages as Any,
            "foodCategory": foodCategory as Any,
            "foodName": foodName as Any,
            "foodWeightAmount": foodWeightAmount as Any,
            "foodWeightType": foodWeightType as Any,
            "foodStatus": foodStatus as Any,
            "expireDate": expireDate as Any,
            "purchaseDate": purchaseDate as Any,
            "foodBrand": foodBrand as Any,
            "priceTracker": priceTracker as Any,
            "additional": additional as Any,
            "createdTime": createdTime as Any
        ]
    }
    
}

/*
 enum CodingKeys: String, CodingKey {
     case foodId
     case foodImages
     case foodCategory
     case foodName
     case foodWeightAmount
 
 }
 
 init(foodId: String, foodImages: String) {
     self.foodId = foodId
     self.foodImages = foodImages
 }

 */
 
