//
//  UserModel.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 30/07/25.
//

import RealmSwift

class UserModel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var username: String
    @Persisted var email: String
    @Persisted var password: String
}
