//
//  ShoppingListManager.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/23/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class ShoppingListManager {
    
    static let shared = ShoppingListManager()
    
    lazy var db = Firestore.firestore()
        
    func fetchAllShoppingListInSingleRefrige(completion: @escaping (Result<[String?], Error>) -> Void) {
        
        let docRef = db.collection("Refrige").document(refrigeNowID)
        //.collection("dwdwdwd")

        docRef.getDocument { (document, error) in
            
            var shopingLists = [String?]()
                do {
                    let shoppingList =  try document?.data(as: Refrige.self, decoder: Firestore.Decoder())
                    guard let shoppingLists = shoppingList?.shoppingList else { return }
                    shopingLists = shoppingLists
                } catch {
                    
                    completion(.failure(error))
                }
                
                completion(.success(shopingLists))
        }
    }
    
    func fetchfoodInfoInsideSingleShoppingList(completion: @escaping (Result<[String?], Error>) -> Void) {
        
        let docRef = db.collection("shoppingList").document(shoppingListNowID)
        docRef.getDocument { (document, error) in
            
            var foodsInfo = [String?]()
                do {
                    let shoppingList =  try document?.data(as: ShoppingList.self, decoder: Firestore.Decoder())
                    guard let shoppingfoodsInfo = shoppingList?.foodID else { return }
                    foodsInfo = shoppingfoodsInfo
                } catch {
                    
                    completion(.failure(error))
                }
                
                completion(.success(foodsInfo))
        }
    }
    
    func postFoodOnShoppingList(shoppingList: inout ShoppingList, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = db.collection("shoppingList").document(shoppingListNowID)
        
        document.updateData(["foodID": shoppingList.foodID])
//        do {
//           try  document.setData(from: shoppingList, merge: true)}
        
//        catch {
//            print("upload error")
//        }
    }
    
    // post refrige shoppingList  UUID
    // post shoppingList  on shoppingList UUID and foodID UUID
        /*
        db.collection(refrigeNowID).getDocuments() { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    
                    var articles = [ShoppingList]()
                    
                    for document in querySnapshot!.documents {

                        do {
                            let article =  try document.data(as: ShoppingList.self, decoder: Firestore.Decoder())
                            articles.append(article)
                        } catch {
                            
                            completion(.failure(error))
                        }
                    }
                    
                    completion(.success(articles))
                }
        }*/

    /*
    func fetchAllFoodInSingleShoppingList(completion: @escaping (Result<[FoodInfo], Error>) -> Void){
        
        db.collection(refrigeNowID).getDocuments() { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    
                    var articles = [ShoppingList]()
                    
                    for document in querySnapshot!.documents {

                        do {
                            let article =  try document.data(as: ShoppingList.self, decoder: Firestore.Decoder())
                            articles.append(article)
                        } catch {
                            
                            completion(.failure(error))
                        }
                    }
                    
                    completion(.success(articles))
                }
        }
    }
     */
}
