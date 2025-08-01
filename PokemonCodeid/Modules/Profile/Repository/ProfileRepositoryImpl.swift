//
//  ProfileRepositoryImpl.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import RealmSwift

class ProfileRepositoryImpl: ProfileRepositoryProtocol {
    private let realm = try? Realm()
    
    func getUserProfile(username: String) -> UserModel? {
        return realm?.objects(UserModel.self).filter("username == %@", username).first
    }
}
