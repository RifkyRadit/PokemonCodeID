//
//  HomepageRepositoryImpl.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Alamofire
import RealmSwift

class HomepageRepositoryImpl: HomepageRepositoryProtocol {
    func getPokemonList(offset: String, completion: @escaping (PokemonListResult) -> Void) {
        let parameterList: Parameters = [
            "limit": "10",
            "offset": offset
        ]
        
        guard CheckConnection().isConnectedToNetwork else {
            let localData = getLocalPokemonList(offset: offset)
            completion(PokemonListResult(data: localData, error: localData.isEmpty ? .noConnection : nil))
            return
        }
        
        APIManager.shared.requestURL(endPoint: APIEndPoint.pokemon.rawValue, method: .get, parameters: parameterList) { result in
            switch result {
            case .success(let data):
                guard let dataRsponse = data else {
                    let localData = self.getLocalPokemonList(offset: offset)
                    completion(PokemonListResult(data: localData, error: localData.isEmpty ? .failed : nil))
                    return
                }
                
                do {
                    let object = try JSONDecoder().decode(PokemonListModel.self, from: dataRsponse)
                    UserDefaults.standard.setValue(object.count, forKey: "countAllPokemonList")
                    self.saveLocalPokemonList(object.results, offset: offset)
                    completion(PokemonListResult(data: object.results, error: nil))
                } catch {
                    UserDefaults.standard.setValue(0, forKey: "countAllPokemonList")
                    completion(PokemonListResult(data: [], error: .failed))
                }
                
            case .failure:
                let localData = self.getLocalPokemonList(offset: offset)
                completion(PokemonListResult(data: localData, error: localData.isEmpty ? .failed : nil))
            }
        }
    }
    
    private func getLocalPokemonList(offset: String) -> [PokemonListModelData] {
        let page = Int(offset) ?? 0
        let realm = try? Realm()
        
        guard let realm = realm else {
            return []
        }
        
        let resultObject = realm.objects(PokemonRealmModel.self).where({ $0.page == page })
        return resultObject.map{ PokemonListModelData(name: $0.name, url: $0.url) }
    }
    
    private func saveLocalPokemonList(_ list: [PokemonListModelData]?, offset: String) {
        let page = Int(offset) ?? 0
        let realm = try? Realm()
        
        do {
            guard let realm = realm, let pokemonList = list, !pokemonList.isEmpty else {
                return
            }
            
            try realm.write({
                for pokemon in pokemonList {
                    let pokemonRealm = PokemonRealmModel()
                    pokemonRealm.id = "\(pokemon.name)_\(page)"
                    pokemonRealm.name = pokemon.name
                    pokemonRealm.url = pokemon.url
                    pokemonRealm.page = page
                    realm.add(pokemonRealm, update: .modified)
                }
            })
            
        } catch {
            print("Error save to realm")
        }
    }
}
