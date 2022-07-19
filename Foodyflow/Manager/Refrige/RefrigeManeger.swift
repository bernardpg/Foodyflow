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
    
    func fetchArticles(userRefrige: [String?], completion: @escaping (Result<[Refrige], Error>) -> Void) {
        
        // USer refrige 
       /* db.collection("Refrige").whereField("id", arrayContainsAny: userRefrige).getDocuments() { (querySnapshot, error) in
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    var articles = [Refrige]()
 
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
        }*/
        
        var articles = [Refrige]()
        for element in userRefrige {
            db.collection("Refrige").whereField("id", isEqualTo: element).getDocuments { (querySnapshot, error) in
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
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
        
    }
    
    func fetchSingleRefrigeInfo(refrige: Refrige, completion: @escaping ((Result<Refrige, Error>) -> Void)) {
        let colref = db.collection("Refrige")
        colref.document(refrige.id).getDocument {
            (document, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                
                do {
                    if let refrigeInfo = try document?.data(as: Refrige.self, decoder: Firestore.Decoder()) {
                        completion(.success(refrigeInfo))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // delete / add within this function 
    func publishFoodOnRefrige(refrige: Refrige, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = db.collection("Refrige").document(refrige.id)
        document.updateData(["foodID": refrige.foodID]) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success"))
            }
        }
    }
    
    func createFrige(refrige: inout Refrige, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = db.collection("Refrige").document()
        refrige.id = document.documentID
        refrige.createdTime = Date().millisecondsSince1970
        document.setData(refrige.toDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success(document.documentID))
            }
        }
    }
    
    func removeFrige(refrigeID: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        refrigeNowID = refrigeID
        
        guard let refrigeNowID = refrigeNowID else { return }
        
        let document = db.collection("Refrige").document(refrigeNowID)
        
        document.delete { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success"))
            }
        }
        
    }
    
    func renameFrige(refrigeID: String, name: String, completion: @escaping () -> Void) {
        
        refrigeNowID = refrigeID
        
        guard let refrigeNowID = refrigeNowID else { return }
        
        let document = db.collection("Refrige").document(refrigeNowID)
        
        document.updateData(["title": name])
        completion()
        
    }
    
}
