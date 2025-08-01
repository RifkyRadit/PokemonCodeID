//
//  DetailPokemonRepositoryProtocol.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation

protocol DetailPokemonRepositoryProtocol {
    func getDetailPokemon(name: String, completion: @escaping(_ data: [AbilitiesModel]?, _ errorState: NetworkErrorType?) -> Void)
}
