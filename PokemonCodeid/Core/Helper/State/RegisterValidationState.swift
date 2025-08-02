//
//  RegisterValidationState.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 30/07/25.
//

import Foundation

enum RegisterValidationState {
    case success
    case usernameAlready
    case emailAlready
    case passowrdNotSame
    case wrongEmailFormat
}
