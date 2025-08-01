//
//  HomepageRepositoryImpl.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Alamofire

class HomepageRepositoryImpl: HomepageRepositoryProtocol {
    func getPokemonList(offset: String, completion: @escaping ([PokemonListModelData]?, NetworkErrorType?) -> Void) {
        var parameterList: Parameters = [
            "limit": "10",
            "offset": offset
        ]
        
        /*
         // TODO: Check conection
         if not connection get local data
         */
        
        APIManager.shared.requestURL(endPoint: APIEndPoint.pokemon.rawValue, method: .get, parameters: parameterList) { result in
            switch result {
            case .success(let data):
                guard let dataRsponse = data else {
                    print(">>> DEBUG sucess data nil, ambil dari lokal")
                    self.getLocalPokemonList()
                    return
                }
                
                do {
                    let object = try JSONDecoder().decode(PokemonListModel.self, from: dataRsponse)
                    completion(object.results, nil)
                } catch {
                    completion(nil, .failed)
                }
                
            case .failure(let failure):
                print(">>> DEBUG sucess data nil, ambil dari lokal")
                self.getLocalPokemonList()
                completion(nil, .failed)
            }
        }
    }
    
    private func getLocalPokemonList() {
        print(">>> DEBUG get lokal realm")
    }
    
    private func saveLocalPokemonList() {
        print(">>> DEBUG save lokal realm")
    }
}
