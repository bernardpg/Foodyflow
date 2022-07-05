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
        
    func fetchAllShoppingListInSingleRefrige(  completion: @escaping (Result<[String?], Error>) -> Void) {
        
        guard let refrigeNowID = refrigeNowID else { return }
        
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
        
        //guard let shoppingListNowID = shoppingListNowID else { return }
        
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
    //MARK: -  delete Food error     //MARK: - delete Food while reload
    func postFoodOnShoppingList(shoppingList: inout ShoppingList, completion: @escaping (Result<String, Error>) -> Void) {
        
     //   guard let shoppingListNowID = shoppingListNowID else { return }
        let document = db.collection("shoppingList").document(shoppingListNowID!)
        
        do {
        document.updateData(["foodID": shoppingList.foodID]) // bug fix
            completion(.success("Success"))
        } catch {
            completion(.failure(error))
        }
        
    }
    
}
