//
//  RefrigeManeger.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/18/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum FirebaseError: Error {
    case documentError
}

enum MasterError: Error {
    case youKnowNothingError(String)
}

class XXXManager {
    
    static let shared = XXXManager()
    
    lazy var db = Firestore.firestore()
    
    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        
        db.collection("articles").order(by: "createdTime", descending: true).getDocuments() { (querySnapshot, error) in
            
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    var articles = [Article]()
                    
                    for document in querySnapshot!.documents {

                        do {
                            let article =  try document.data(as: Article.self, decoder: Firestore.Decoder())
                            articles.append(article)
                            //let article = try document.data(as: Article.self, decoder: Firestore.Decoder()) {
                           //     articles.append(article)
                            
                        } catch {
                            
                            completion(.failure(error))
//                            completion(.failure(FirebaseError.documentError))
                        }
                    }
                    
                    completion(.success(articles))
                }
        }
    }
    
    func publishArticle(article: inout Article, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = db.collection("articles").document()
        article.id = document.documentID
        article.createdTime = Date().millisecondsSince1970
        document.setData(article.toDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success"))
            }
        }
    }
}
