//
//  RegisterUseCaseProtocol.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 30/07/25.
//

import Foundation

protocol RegisterUseCaseProtocol {
    func validateUserProfile(username: String, email: String, password: String, confirmPassword: String) -> RegisterValidationState
    func registerUser(username: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}
