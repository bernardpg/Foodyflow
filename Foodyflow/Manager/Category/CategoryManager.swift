//
//  CategoryManager.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/20/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class CategoryManager {
    
    static let shared = CategoryManager()
    
    lazy var db = Firestore.firestore()
    
    func fetchArticles(completion: @escaping (Result<[Category], Error>) -> Void) {
        
       let docref = db.collection("category").document("v8pyHTdy3fm6FiEg3Ea1")
        
        docref.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                var articles = [Category]()
                do {
                    let article =  try document?.data(as: Category.self, decoder: Firestore.Decoder())
                    guard let article = article else { return }
                    articles.append(article)
                } catch {
                    
                    completion(.failure(error))
                }
                
                completion(.success(articles))
        }
        }
    }
}
