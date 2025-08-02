//
//  HomepageUseCaseProtocol.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation

protocol HomepageUseCaseProtocol {
    func fetchPokemonList(offset: String, completion: @escaping(PokemonListResult) -> Void)
}
