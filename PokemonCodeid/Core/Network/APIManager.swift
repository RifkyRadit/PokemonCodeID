//
//  APIManager.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation
import Alamofire

enum APIEndPoint: String {
    case pokemon = "pokemon"
}

enum NetworkErrorType {
    case empty
    case failed
}

class APIManager {
    static let shared = APIManager()
    
    private let baseURl = "https://pokeapi.co/api/v2/"
    
    private init() { }
    
    func requestURL(
        endPoint: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping(Result<Data?, AFError>) -> Void)
    {
        let url = baseURl + endPoint
        let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
        
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().response { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
