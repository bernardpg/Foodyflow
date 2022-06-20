//
//  CategoryManager.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/20/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


class CategoryManager{
    
    static let shared = CategoryManager()
    
    lazy var db = Firestore.firestore()
    
    func fetchArticles(completion: @escaping (Result<[Category], Error>) -> Void) {
        
        db.collection("category").getDocuments() { (querySnapshot, error) in
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    var articles = [Category]()
                    print(articles)
                    
                    for document in querySnapshot!.documents {

                        do {
                            let article =  try document.data(as: Category.self, decoder: Firestore.Decoder())
                            articles.append(article)
                        } catch {
                            
                            completion(.failure(error))
                        }
                    }
                    
                    completion(.success(articles))
                }
        }
    }
    /*
    func publishFoodOnRefrige(refrige: inout Category, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = db.collection("category").document(refrige.id)
        document.updateData(["foodID" : refrige.foodID]) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
//                article.foodID.append(foodId!)
//                articles.append(article)

                completion(.success("Success"))
            }
        }
    }
}

*/
    
}
