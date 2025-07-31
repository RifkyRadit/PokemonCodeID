//
//  LoginUseCaseProtocol.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation

protocol LoginUseCaseProtocol {
    func userLogin(username: String, password: String) -> LoginResult
}
