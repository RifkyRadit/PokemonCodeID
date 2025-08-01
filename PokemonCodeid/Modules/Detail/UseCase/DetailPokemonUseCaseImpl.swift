//
//  DetailPokemonUseCaseImpl.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation

class DetailPokemonUseCaseImpl: DetailPokemonUseCaseProtocol {
    private let repository: DetailPokemonRepositoryProtocol
    
    public init(repository: DetailPokemonRepositoryProtocol = DetailPokemonRepositoryImpl()) {
        self.repository = repository
    }
    
    func fetchDetailPokemon(name: String, completion: @escaping ([AbilitiesModel]?, NetworkErrorType?) -> Void) {
        repository.getDetailPokemon(name: name, completion: completion)
    }
}
