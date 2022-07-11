//
//  AuthManager.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/29/22.
//

import Foundation
import FirebaseAuth

struct AuthManager {
    
    private let auth = Auth.auth()
    
    enum AuthError: Error {
        case unknownError
    }
    
    func signUpNewUser(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            } else {
                completion(.failure(AuthError.unknownError))
            }
        }
    }
    
    func loginUser(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            } else {
                completion(.failure(AuthError.unknownError))
            }
        }
    }
    
    func resetPassword(withEmail email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func logoutUser() -> Result<Void, Error> {
        do {
            try Auth.auth().signOut()
            return .success(())
        } catch (let error) {
            return .failure(error)
        }
    }
    

}
