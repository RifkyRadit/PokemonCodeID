//
//  HomepageUseCaseImpl.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation

class HomepageUseCaseImpl: HomepageUseCaseProtocol {
    private var repository: HomepageRepositoryProtocol
    
    public init(repository: HomepageRepositoryProtocol = HomepageRepositoryImpl()) {
        self.repository = repository
    }
    
    func fetchPokemonList(offset: String, completion: @escaping (PokemonListResult) -> Void) {
        repository.getPokemonList(offset: offset) { result in
            completion(result)
        }
    }
}
