//
//  ProfileRepositoryProtocol.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation

protocol ProfileRepositoryProtocol {
    func getUserProfile(username: String) -> UserModel?
}
