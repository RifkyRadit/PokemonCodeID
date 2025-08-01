//
//  ErrorStateEnum.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 01/08/25.
//

enum ErrorState {
    case generalError
    case noConnection
    case emptyPokemonList
    case emptyAbility
    case emptySearch
    
    var titleText: String {
        switch self {
        case .generalError:
            return "Terjadi Kesalahan"
        case .noConnection:
            return "Tidak Ada Koneksi"
        case .emptyPokemonList, .emptyAbility:
            return "Data Kosong"
        case .emptySearch:
            return "Hasil Tidak Ditemukan"
        }
    }
    
    var descriptionText: String {
        switch self {
        case .generalError:
            return "Ada masalah saat memuat data. Silakan coba beberapa saat lagi."
        case .noConnection:
            return "Periksa koneksi internet Anda, lalu coba lagi."
        case .emptyPokemonList:
            return "Tidak ada Pokémon yang tersedia saat ini. Silakan coba beberapa saat lagi."
        case .emptyAbility:
            return "Pokémon ini tidak memiliki kemampuan yang tersedia."
        case .emptySearch:
            return "Tidak ada Pokémon yang cocok dengan pencarian Anda."
        }
    }
    
    var iconImage: String {
        switch self {
        case .generalError:
            return "icon_error"
        case .noConnection:
            return "icon_no_internet"
        case .emptyPokemonList, .emptySearch, .emptyAbility:
            return "icon_empty"
        }
    }
}
