//
//  DetailPokemonUseCaseProtocol.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation

protocol DetailPokemonUseCaseProtocol {
    func fetchDetailPokemon(name: String, completion: @escaping(_ data: [AbilitiesModel]?, _ errorState: NetworkErrorType?) -> Void)
}
