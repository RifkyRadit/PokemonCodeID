//
//  LoginRepositoryProtocol.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation

protocol LoginRepositoryProtocol {
    func getUser(username: String) -> UserModel?
}
