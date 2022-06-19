//
//  RecipeManager.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/19/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class RecipeManager {
    
    static let shared = RecipeManager()
    
    lazy var db = Firestore.firestore()/*
    
    func fetchFoods(completion: @escaping (Result<[FoodInfo], Error>) -> Void) {
        
        db.collection("articles").order(by: "createdTime", descending: true).getDocuments() { (querySnapshot, error) in
            
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    var foods = [FoodInfo]()
                    
                    for document in querySnapshot!.documents {

                        do {
                            let food =  try document.data(as: FoodInfo.self, decoder: Firestore.Decoder())
                            foods.append(food)
                            //let article = try document.data(as: Article.self, decoder: Firestore.Decoder()) {
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
        
        let document = db.collection("articles").document()
        food.foodId = document.documentID
        food.createdTime = Date().millisecondsSince1970
        document.setData(food.toDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success"))
            }
        }
    }
                                        */
}

