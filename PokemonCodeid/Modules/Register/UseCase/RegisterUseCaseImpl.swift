//
//  RegisterUseCaseImpl.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 30/07/25.
//

import Foundation

class RegisterUseCaseImpl: RegisterUseCaseProtocol {
    private let repository: RegisterRepositoryProtocol
    
    public init(repository: RegisterRepositoryProtocol) {
        self.repository = repository
    }
    
    init() {
        self.repository = RegisterRepositoryImpl()
    }
    
    func validateUserProfile(username: String, email: String, password: String, confirmPassword: String) -> RegisterValidationState {
        repository.validateUserProfile(username: username, email: email, password: password, confirmPassword: confirmPassword)
    }
    
    func registerUser(username: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.saveUser(username: username, email: email, password: password, completion: completion)
    }
}
