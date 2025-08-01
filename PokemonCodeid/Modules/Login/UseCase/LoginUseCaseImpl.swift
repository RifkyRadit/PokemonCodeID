//
//  LoginUseCaseImpl.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation

class LoginUseCaseImpl: LoginUseCaseProtocol {
    private let repository: LoginRepositoryProtocol
    
    public init(repository: LoginRepositoryProtocol = LoginRepositoryImpl()) {
        self.repository = repository
    }
    
    func userLogin(username: String, password: String) -> LoginResult {
        let userModel = repository.getUser(username: username)
        
        guard let data = userModel else {
            return .userNotFound
        }
        
        if !data.password.isEmpty, data.password == password {
            UserDefaults.standard.setValue(username, forKey: "usernameProfile")
            return .successLogin
        } else {
            return .wrongPassword
        }
    }
}
