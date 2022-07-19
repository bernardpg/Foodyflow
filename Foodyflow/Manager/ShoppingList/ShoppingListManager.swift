//
//  ShoppingListManager.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/23/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestoreSwift

class ShoppingListManager {
    
    static let shared = ShoppingListManager()
    
    lazy var db = Firestore.firestore()
    
    let database = Firestore.firestore().collection("User")
        
    func fetchAllShoppingListIDInSingleRefrige( completion: @escaping (Result<[String?], Error>) -> Void) {
        
        guard let refrigeNowID = refrigeNowID else { completion(.success([])); return }
        
        // Refrige empty
        let shoppingLists: [String?] = []
        guard !refrigeNowID.isEmpty else { completion(.success(shoppingLists)); return }
        let docRef = db.collection("Refrige").document(refrigeNowID)
        // .collection("dwdwdwd")

        docRef.getDocument { (document, error) in
            
            var shopingLists = [String?]()
                do {
                    let refrige =  try document?.data(as: Refrige.self, decoder: Firestore.Decoder())
                    guard let shoppingLists = refrige?.shoppingList else { return }
                    shopingLists = shoppingLists
 //                   if shoppingLists.isEmpty {
 //                       print("empty")
 //                       completion(.failure)
 //                   }
                } catch {
                    
                    completion(.failure(error))
                }
                
                completion(.success(shopingLists))
        }
    }
    
    func fetchALLShopListInfoInSingleRefrige(shopplingLists: [String?], completion: @escaping (Result<ShoppingList?, Error >) -> Void) {
    let colRef = db.collection("shoppingList")
    
    for shopplingList in shopplingLists {
        guard let shopplingList = shopplingList else { return }
        colRef.document(shopplingList).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                
                do {
                    if let shoppingList = try document?.data(as: ShoppingList.self, decoder: Firestore.Decoder()) {
                        completion(.success(shoppingList))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
}
    
    func fetchShopListInfo(shopplingListID: String?, completion: @escaping(Result<ShoppingList?, Error>) -> Void) {
        
        let colRef = db.collection("shoppingList")
        
        guard let shopplingListID = shopplingListID else {
            return }
        colRef.document(shopplingListID).getDocument { (document, error) in
            
            do {
                let shopList =  try document?.data(as: ShoppingList.self, decoder: Firestore.Decoder())
                
                completion(.success(shopList))
            } catch {
                
                completion(.failure(error))
            }

        }
        
    }
    
    func fetchfoodInfoInsideSingleShoppingList(completion: @escaping (Result<[String?], Error>) -> Void) {
        
        // guard let shoppingListNowID = shoppingListNowID else { return }
        
        let docRef = db.collection("shoppingList").document(shoppingListNowID!)
        
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
    
     // need to fix bugs while Delete
    // MARK: delete Food while reload

    // MARK: delete Food error
    func postFoodOnShoppingList( shoppingList: inout ShoppingList,
                                 completion: @escaping (Result<String, Error>) -> Void ) {
        
     //   guard let shoppingListNowID = shoppingListNowID else { return }
        
        let document = db.collection("shoppingList").document(shoppingListNowID!)
        
        do {
        document.updateData(["foodID": shoppingList.foodID]) // bug fix
            completion(.success("Success"))} catch {
            completion(.failure(error))
        }
    }
    
    func createShoppingList(shoppingList: inout ShoppingList,
                            refrigeID: String,
                            completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = db.collection("shoppingList").document()
        shoppingList.id = document.documentID
        let refrigeRef = db.collection("Refrige").document(refrigeID)
        
        refrigeRef.updateData([ "shoppingList": FieldValue.arrayUnion([shoppingList.id])])
        
        document.setData(shoppingList.toDict) { error in
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success(document.documentID))
            }
        }
    }

    func createShoppingListOnSingleUser(user: UserInfo, refrigeID: [String?], completion: @escaping (Result<String, Error>) -> Void ) {

        let userRef = database.document(user.userID)
        
        userRef.updateData(["personalRefrige": refrigeID]) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("success"))
            }
        }
        
    }

}
