//
//  ProfileUseCaseImpl.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation

class ProfileUseCaseImpl: ProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    
    public init(repository: ProfileRepositoryProtocol = ProfileRepositoryImpl()) {
        self.repository = repository
    }
    
    func fetchUserProfile(username: String) -> UserModel? {
        return repository.getUserProfile(username: username)
    }
}
