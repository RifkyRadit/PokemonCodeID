//
//  PokemonListModel.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation

// MARK: - PokemonListModel
struct PokemonListModel: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [PokemonListModelData]?
}

// MARK: - Result
struct PokemonListModelData: Codable {
    let name: String
    let url: String
}
