//
//  DetailPokemonViewModel.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation
import RxSwift
import RxRelay

enum DetailViewState: Equatable {
    case loading
    case showContent(_ data: [AbilitiesModel])
    case failure(_ errorState: ErrorState)
}

protocol DetailPokemonViewModelType {
    var inputs: DetailPokemonViewModelInput { get }
    var outputs: DetailPokemonViewModelOutput { get }
}

protocol DetailPokemonViewModelInput {
    func viewDidLoad(pokemonName: String)
}

protocol DetailPokemonViewModelOutput {
    var state: Observable<DetailViewState?> { get }
}

final class DetailPokemonViewModel: DetailPokemonViewModelInput {
    
    private var detailPokemonUseCase: DetailPokemonUseCaseProtocol
    
    private var stateVariable = BehaviorRelay<DetailViewState?>(value: nil)
    
    init(detailPokemonUseCase: DetailPokemonUseCaseProtocol = DetailPokemonUseCaseImpl()) {
        self.detailPokemonUseCase = detailPokemonUseCase
    }
    
    func viewDidLoad(pokemonName: String) {
        stateVariable.accept(.loading)
        fetchDetailPokemon(with: pokemonName)
    }
}

extension DetailPokemonViewModel {
    private func fetchDetailPokemon(with name: String) {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.5) { [weak self] in
            guard let self else { return }
            
            guard CheckConnection().isConnectedToNetwork else {
                self.stateVariable.accept(.failure(.noConnection))
                return
            }
            
            self.detailPokemonUseCase.fetchDetailPokemon(name: name) { data, errorState in
                if let errorState = errorState {
                    switch errorState {
                    case .emptyApi:
                        self.stateVariable.accept(.failure(.emptyAbility))
                    case .failed:
                        self.stateVariable.accept(.failure(.generalError))
                    case .noConnection:
                        self.stateVariable.accept(.failure(.noConnection))
                    }
                    
                } else {
                    if let dataPokemon = data {
                        self.stateVariable.accept(dataPokemon.isEmpty ? .failure(.emptyAbility) : .showContent(dataPokemon))
                    } else {
                        self.stateVariable.accept(.failure(.generalError))
                    }
                }
            }
        }
    }
}

extension DetailPokemonViewModel: DetailPokemonViewModelType {
    var inputs: DetailPokemonViewModelInput { return self }
    var outputs: DetailPokemonViewModelOutput { return self }
}

extension DetailPokemonViewModel: DetailPokemonViewModelOutput {
    var state: Observable<DetailViewState?> {
        return stateVariable.asObservable()
    }
}
