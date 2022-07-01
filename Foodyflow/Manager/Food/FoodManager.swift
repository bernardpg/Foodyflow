//
//  FoodManager.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/18/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
var foodId: String?

class FoodManager {
    
    static let shared = FoodManager()
    
    lazy var db = Firestore.firestore()
    
    func fetchFoods(completion: @escaping (Result<[FoodInfo], Error>) -> Void) {
        
        db.collection("foods").order(by: "createdTime", descending: true).getDocuments() { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                var foods = [FoodInfo]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        let food =  try document.data(as: FoodInfo.self, decoder: Firestore.Decoder())
                        foods.append(food)
                        //  let article = try document.data(as: Article.self, decoder: Firestore.Decoder()) {
                        //     articles.append(article)
                        
                    } catch {
                        
                        completion(.failure(error))
                        //                            completion(.failure(FirebaseError.documentError))
                    }
                }
                
                completion(.success(foods))
            }
        }
    }
    
    func publishFood(food: inout FoodInfo, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = db.collection("foods").document()
        foodId = document.documentID
        food.foodId = document.documentID
        food.foodBrand = "33" // rename
        food.createdTime = Date().millisecondsSince1970
        document.setData(food.toDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success"))
            }
        }
    }
    // need to refactor
    func fetchSpecifyFood(refrige: Refrige, completion: @escaping (Result<FoodInfo, Error>) -> Void) {
        let colref = db.collection("foods")
        let foods = FoodInfo()
        guard !refrige.foodID.isEmpty else {
            completion(.success(foods))
            return
        }
        for food in refrige.foodID {
            colref.document(food).getDocument { (document, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    
                    do {
                        if let foodInfo = try document?.data(as: FoodInfo.self, decoder: Firestore.Decoder()) {
                            completion(.success(foodInfo))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func fetchSpecifyFoodInShopping(foods: [String?], completion: @escaping (Result<FoodInfo,Error>) -> Void) {
        let colref = db.collection("foods")
        
        let foodInfo = FoodInfo()
        guard !foods.isEmpty else  { return completion(.success(foodInfo))}
        for food in foods {
            guard let food = food else { return }
            colref.document(food).getDocument { (document, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    
                    do {
                        if let foodInfo = try document?.data(as: FoodInfo.self, decoder: Firestore.Decoder()) {
                            completion(.success(foodInfo))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        
    }
    
    func changeFoodStatus(foodId: String?, foodStatus: Int, completion: @escaping () -> Void) {
        
        let colref = db.collection("foods")
        
        guard let foodId = foodId else { return }
        colref.document( foodId ).setData( [ "foodStatus": foodStatus ], merge: true )
        completion()
        
    }
    
    // delete food by foodID
    
    func deleteFood(foodId: String?, completion: @escaping (Result<String?, Error>) -> Void) {
        
        let colref = db.collection("foods")
        
        guard let foodId = foodId else { return }
        
        colref.document(foodId).delete { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success"))
            }
        }
    }
    
    
}
