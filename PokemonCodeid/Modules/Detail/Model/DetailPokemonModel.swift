//
//  DetailPokemonModel.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation

// MARK: - DetailPokemonModel
struct DetailPokemonModel: Codable {
    let abilities: [AbilitiesModel]
}

// MARK: - Abilities
struct AbilitiesModel: Codable, Equatable {
    let ability: Ability?
    let isHidden: Bool
    let slot: Int

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}

// MARK: - Ability
struct Ability: Codable, Equatable {
    let name: String
    let url: String
}
