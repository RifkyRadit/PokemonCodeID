//
//  RegisterRepositoryImpl.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 30/07/25.
//

import Foundation
import RealmSwift

class RegisterRepositoryImpl: RegisterRepositoryProtocol {
    
    private let realm = try? Realm()
    
    func validateUserProfile(username: String, email: String, password: String, confirmPassword: String) -> RegisterValidationState {
        if ((realm?.objects(UserModel.self).filter("username == %@", username).first) != nil) {
            return .usernameAlready
        } else if ((realm?.objects(UserModel.self).filter("email == %@", email).first) != nil) {
            return .emailAlready
        } else if password != confirmPassword {
            return .passowrdNotSame
        } else if !validateEmail(email: email) {
            return .wrongEmailFormat
        }else {
            return .success
        }
    }
    
    func saveUser(username: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let salt = generateSalt()
        let passHashed = hashPassword(password, salt: salt)
        
        let user = UserModel()
        user.username = username
        user.email = email
        user.salt = salt
        user.hashPass = passHashed
        
        do {
            try self.realm?.write({
                self.realm?.add(user)
            })
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
