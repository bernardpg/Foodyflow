//
//  UserManager.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/18/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
// fetch data create user // user default
// each page different part verify Userdeafult
class UserManager {
    
    enum Result<T> {
        
        case success(T)
        
        case failure(Error)
        
    }
    
    static let shared = UserManager()
    
    let database = Firestore.firestore().collection("User")
    
    func addUserInfo(user: UserInfo) {
        
        do {
            
            try database.document(user.userID).setData(from: user, merge: true)
            
        } catch {
            
        }
        
    }

    func fetchUserInfo(fetchUserID: String, completion: @escaping (Result<UserInfo>) -> Void) {
        // User 第一次時會有找不到 bug 
        guard !fetchUserID.isEmpty else { completion(Result.failure(MasterError.youKnowNothingError("error"))); return }
        
        database.document(fetchUserID).getDocument { snapshot, error in
            
            guard let snapshot = snapshot else {
                
                completion(Result.failure(error!))
                
                return
                
            }

            do {
                
                if let user = try snapshot.data(as: UserInfo?.self, decoder: Firestore.Decoder()) {
                    
                    completion(.success(user))
                    
                }
                
            } catch {
                
                completion(Result.failure(error))
                
            }
            
        }
        
        // fetch Userdata not in DB
        
    }
    
    func updateUserInfo(user: UserInfo, completion: @escaping () -> Void ) {
        
        do {
            
                
                try database.document(user.userID).setData(from: user, merge: true)
                
                completion()
            
        } catch {
            
            HandleResult.updateDataFailed.messageHUD
            
        }
        
    }
    
    func createRefrigeOnSingleUser(user: UserInfo, refrigeID: [String?],
                                   completion: @escaping (Result<String>) -> Void) {
        let userRef = database.document(user.userID)
        
        userRef.updateData(["personalRefrige": refrigeID]) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("success"))
            }
        }
        
    }
    
    func deleteUser(userID: String, completion: @escaping() -> Void) {
        
        // delete User
        
        let userRef = database.document(userID)
            userRef.delete()
            completion()
        
    }
    
    func addBlockList(uid: String, blockID: String, completion: @escaping (Result<Void>) -> Void) {

        let userRef = database.document(uid)

       userRef.updateData(["blockLists": FieldValue.arrayUnion([blockID])]) { error in
            
            if let error = error {
                print(error)
            } else {
                print("Document Update!")
                completion(.success(()))
            }
        }
        
    }
    
    func removeBlockList(uid: String, blockID: String, completion: @escaping (Result<Void>) -> Void) {
        
        let userRef = database.document(uid)
        
        userRef.updateData(["blockLists": FieldValue.arrayRemove([blockID])]) { error in
            
            if let error = error {
                print(error)
            } else {
                print("Document Update!")
                completion(.success(()))
            }
        }
    }
    
}
