//
//  RecipeManager.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/19/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth

class RecipeManager {
    
    static let shared = RecipeManager()
    
    lazy var db = Firestore.firestore()
    
    // create
    
    // photos
    
    // create recipe and 收藏 個人 封鎖 
    
    func createRecipe( recipe: inout Recipe, completion: @escaping (Result<String, Error>) -> Void) {
        
        HandleResult.imageUpload.messageHUD
        
        let document = db.collection("recipe").document()
        recipe.recipeID = document.documentID
        document.setData(recipe.toDict) { error in
            
            if let error = error {
                HandleResult.imageUploadFailed.messageHUD
                completion(.failure(error))
            } else {
                
                HandleResult.imageUploadSuccess.messageHUD
                completion(.success("Success"))
            }
        }
    }    
    // read
    func fetchAllRecipe ( completion: @escaping((Result<[Recipe], Error>) -> Void )) {
        
        let collection = db.collection("recipe")
        
        collection.getDocuments { (querySnapshot, error) in
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                var recipes = [Recipe]()

                for document in querySnapshot!.documents {

                    do {
                        let recipe =  try document.data(as: Recipe.self, decoder: Firestore.Decoder())
                        recipes.append(recipe)
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
                completion(.success(recipes))
            }
    }
        
    }
    // delete by user
    func deleteRecipe (recipesID: [String?]) {
        
        let colRef = db.collection("recipe")
        
        for element in recipesID {
            guard let element = element else { return }
            colRef.document(element).delete()
        }
    }
    
    func fetchFoodinRecipe () {
        
    }
    //
    func personalRecipe() {
        
    }
    
    func fetchSingleRecipe( recipe: Recipe, completion: @escaping(Result<Recipe, Error>) -> Void) {
         let collection = db.collection("recipe")
        
        collection.document(recipe.recipeID).getDocument {
            (document, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                do {
                    if let recipe = try document?.data(as: Recipe.self, decoder: Firestore.Decoder()) {
                        completion(.success(recipe))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchSingleReci( recipe: String, completion: @escaping(Result<Recipe, Error>) -> Void) {
         let collection = db.collection("recipe")
        
        collection.document(recipe).getDocument {
            (document, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                do {
                    if let recipe = try document?.data(as: Recipe.self, decoder: Firestore.Decoder()) {
                        completion(.success(recipe))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }

}
