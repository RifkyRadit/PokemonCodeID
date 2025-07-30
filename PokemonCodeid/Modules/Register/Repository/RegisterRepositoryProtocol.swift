//
//  RegisterRepositoryProtocol.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 30/07/25.
//

import Foundation

protocol RegisterRepositoryProtocol {
    func validateUserProfile(username: String, email: String, password: String, confirmPassword: String) -> RegisterValidationState
    func saveUser(username: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}
