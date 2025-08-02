//
//  HomepageViewModel.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation
import RxSwift
import RxRelay

enum HomepageViewState {
    case loading
    case error
    case empty
    case showContent(_ data: [PokemonListModelData])
    case noConnection
}

protocol HomepageViewModelType {
    var inputs: HomepageViewModelInput { get }
    var outputs: HomepageViewModelOutput { get }
}

protocol HomepageViewModelInput {
    func viewDidLoad()
    func loadNextPage()
}

protocol HomepageViewModelOutput {
    var state: Observable<HomepageViewState?> { get }
}

final class HomepageViewModel: HomepageViewModelInput {
    
    private var homepageUseCase: HomepageUseCaseProtocol
    
    private var stateVariable = BehaviorRelay<HomepageViewState?>(value: nil)
    
    private var totalCountList = 0
    private var currentOffset = 0
    private var pokemonList = [PokemonListModelData]()
    
    init(homepageUseCase: HomepageUseCaseProtocol = HomepageUseCaseImpl()) {
        self.homepageUseCase = homepageUseCase
    }
    
    func viewDidLoad() {
        currentOffset = 0
        pokemonList = []
        stateVariable.accept(.loading)
        getPokemonList()
    }
    
    func loadNextPage() {
        stateVariable.accept(.loading)
        guard pokemonList.count < totalCountList else {
            return
        }
        
        getPokemonList()
    }
}

extension HomepageViewModel {
    private func getPokemonList() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self else { return }
            
            self.homepageUseCase.fetchPokemonList(offset: "\(self.currentOffset)") { result in
                self.totalCountList = UserDefaults.standard.integer(forKey: "countAllPokemonList")
                
                if let resultData = result.data, !resultData.isEmpty {
                    self.pokemonList.append(contentsOf: resultData)
                    self.currentOffset += 10
                }
                
                self.stateVariable.accept(.showContent(self.pokemonList))
                
                guard let resultError = result.error, self.currentOffset == 0 else {
                    return
                }
                
                switch resultError {
                case .emptyApi:
                    self.stateVariable.accept(.empty)
                case .failed:
                    self.stateVariable.accept(.error)
                case .noConnection:
                    self.stateVariable.accept(.noConnection)
                }
            }
        }
    }
}

extension HomepageViewModel: HomepageViewModelType {
    var inputs: HomepageViewModelInput { return self }
    var outputs: HomepageViewModelOutput { return self }
}

extension HomepageViewModel: HomepageViewModelOutput {
    var state: Observable<HomepageViewState?> {
        return stateVariable.asObservable()
    }
}
