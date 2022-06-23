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


class RefrigeManager {
    
    static let shared = RefrigeManager()
    
    lazy var db = Firestore.firestore()
    
    func fetchArticles(completion: @escaping (Result<[Refrige], Error>) -> Void) {
        
        db.collection("Refrige").getDocuments() { (querySnapshot, error) in
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    var articles = [Refrige]()
                    print(articles)
                    
                    for document in querySnapshot!.documents {

                        do {
                            let article =  try document.data(as: Refrige.self, decoder: Firestore.Decoder())
                            articles.append(article)
                        } catch {
                            
                            completion(.failure(error))
                        }
                    }
                    
                    completion(.success(articles))
                }
        }
    }
    
    func publishFoodOnRefrige(refrige: inout Refrige, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = db.collection("Refrige").document(refrige.id)
        document.updateData(["foodID": refrige.foodID]) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
//                article.foodID.append(foodId!)
//                articles.append(article)

                completion(.success("Success"))
            }
        }
    }
    
    func createFrige(refrige: inout Refrige, completion: @escaping (Result<String, Error>) -> Void){
        
        let document = db.collection("Refrige").document()
        refrige.id = document.documentID
        refrige.createdTime = Date.now.millisecondsSince1970
        document.setData(refrige.toDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success"))
            }
        }
        
    }
}
