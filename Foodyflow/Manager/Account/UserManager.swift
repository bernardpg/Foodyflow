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
            
        //    HandleResult.addDataFailed.messageHUD
            
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
            
         //   if !KeyToken().userID.isEmpty {
                
                try database.document(user.userID).setData(from: user, merge: true)
                
                completion()
 //           }
            
        } catch {
            
            HandleResult.updateDataFailed.messageHUD
            
        }
        
    }
    
    func createRefrigeOnSingleUser(user: UserInfo, refrigeID: [String?], completion: @escaping (Result<String>) -> Void) {
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
    
    /*
    
    func fetchUserInfo(fetchUserID: String, completion: @escaping (Result<UserInfo>) -> Void) {
        
        database.document(fetchUserID).getDocument { snapshot, error in
            
            guard let snapshot = snapshot else {
                
                completion(Result.failure(error!))
                
                return
                
            }

            do {
                
                if let user = try snapshot.data(as: UserInfo.self, decoder: Firestore.Decoder()) {
                    
                    completion(Result.success(user))
                    
                }
                
            } catch {
                
                completion(Result.failure(error))
                
            }
            
        }
        
    }
    
    func listenUserInfo(completion: @escaping (Result<UserInfo>) -> Void) {
        
        if !KeyToken().userID.isEmpty {
            
            database.document(KeyToken().userID).addSnapshotListener { snapshot, error in
                
                guard let snapshot = snapshot else {
                    
                    completion(Result.failure(error!))
                    
                    return
                    
                }
  
                do {
                    
                    if let user = try snapshot.data(as: UserInfo.self, decoder: Firestore.Decoder()) {
                        
                        completion(Result.success(user))
                        
                    }
                    
                } catch {
                    
                    completion(Result.failure(error))
                    
                }
                
            }
            
        }
        
    }
    
    func updateUserInfo(user: UserInfo) {
        
        do {
            
            if !KeyToken().userID.isEmpty {
                
                try database.document(KeyToken().userID).setData(from: user, merge: true)
                
            }
            
        } catch {
            
    //        HandleResult.updateDataFailed.messageHUD
            
        }
        
    }
     */
    
    /*
    func fetchUsersInfo(completion: @escaping (Result<[UserInfo]>) -> Void) {
        
        var usersInfo: [UserInfo] = []
        
        database.getDocuments { snapshot, error in
            
            guard let snapshot = snapshot else {
                
                completion(Result.failure(error!))
                
                return
                
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    if let userInfo = try document.data(as: UserInfo.self, decoder: Firestore.Decoder()) {
                        
                        usersInfo.append(userInfo)
                        
                    }
                    
                } catch {
                    
                    completion(Result.failure(error))

                }
                
            }
            
            completion(Result.success(usersInfo))
            
        }
        
    }
*/
    
}
