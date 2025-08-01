//
//  ProfileUseCaseProtocol.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation

protocol ProfileUseCaseProtocol {
    func fetchUserProfile(username: String) -> UserModel?
}
