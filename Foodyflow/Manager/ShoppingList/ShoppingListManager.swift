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
        
    func fetchAllShoppingListIDInSingleRefrige(  completion: @escaping (Result<[String?], Error>) -> Void) {
        
        guard let refrigeNowID = refrigeNowID else { return }
        
        let docRef = db.collection("Refrige").document(refrigeNowID)
        // .collection("dwdwdwd")

        docRef.getDocument { (document, error) in
            
            var shopingLists = [String?]()
                do {
                    let refrige =  try document?.data(as: Refrige.self, decoder: Firestore.Decoder())
                    guard let shoppingLists = refrige?.shoppingList else { return }
                    shopingLists = shoppingLists
                } catch {
                    
                    completion(.failure(error))
                }
                
                completion(.success(shopingLists))
        }
    }
    
    func fetchALLShopListInfoInSingleRefrige(shopplingLists: [String], completion: @escaping  (Result<[ShoppingList?], Error >) -> Void) {
        
        
        //let // fix bug 
        var storeshopplingList: [ShoppingList] = [ ]
        
        for shopplingList in shopplingLists {
            db.collection("shoppingList").document(shopplingList).getDocument { (document, error) in
                
                do {
                    let shoppingList =  try document?.data(as: ShoppingList.self, decoder: Firestore.Decoder())
                    guard let shoppingList = shoppingList else { return }
                    storeshopplingList.append(shoppingList)
                } catch {
                    
                    completion(.failure(error))
                }
                
            }
            completion(.success(storeshopplingList))
    }

    //     let colDef = db.collection()
      //  let colDef = db.collectionGroup(<#T##String#>)
        
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
    
    // func createShoppingList() {
    //
   // }
}
