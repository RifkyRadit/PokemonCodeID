//
//  DetailPokemonRepositoryImpl.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation
import Alamofire

class DetailPokemonRepositoryImpl: DetailPokemonRepositoryProtocol {
    func getDetailPokemon(name: String, completion: @escaping ([AbilitiesModel]?, NetworkErrorType?) -> Void) {
        let endpoint = APIEndPoint.pokemon.rawValue + "/\(name)"
        
        APIManager.shared.requestURL(endPoint: endpoint, method: .get) { result in
            switch result {
            case .success(let data):
                guard let dataRsponse = data else {
                    completion(nil, .failed)
                    return
                }
                
                do {
                    let object = try JSONDecoder().decode(DetailPokemonModel.self, from: dataRsponse)
                    completion(object.abilities, nil)
                } catch {
                    completion(nil, .failed)
                }
                
            case .failure:
                completion(nil, .failed)
            }
        }
    }
}
