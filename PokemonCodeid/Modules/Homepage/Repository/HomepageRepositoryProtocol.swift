//
//  HomepageRepositoryProtocol.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation

protocol HomepageRepositoryProtocol {
    func getPokemonList(offset: String, completion: @escaping(PokemonListResult) -> Void)
}
