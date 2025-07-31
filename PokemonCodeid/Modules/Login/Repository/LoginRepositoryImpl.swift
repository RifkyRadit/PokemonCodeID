//
//  LoginRepositoryImpl.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation
import RealmSwift

class LoginRepositoryImpl: LoginRepositoryProtocol {
    private let realm = try? Realm()
    
    func getUser(username: String) -> UserModel? {
        return realm?.objects(UserModel.self).filter("username == %@", username).first
    }
}
