//
//  PokemonRealmModel.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 01/08/25.
//

import RealmSwift

class PokemonRealmModel: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var url: String
    @Persisted var page: Int
}
