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
}

protocol HomepageViewModelType {
    var inputs: HomepageViewModelInput { get }
    var outputs: HomepageViewModelOutput { get }
}

protocol HomepageViewModelInput {
    func viewDidLoad(offset: Int)
}

protocol HomepageViewModelOutput {
    var state: Observable<HomepageViewState?> { get }
}

final class HomepageViewModel: HomepageViewModelInput {
    
    private var homepageUseCase: HomepageUseCaseProtocol
    
    private var stateVariable = BehaviorRelay<HomepageViewState?>(value: nil)
    
    init(homepageUseCase: HomepageUseCaseProtocol = HomepageUseCaseImpl()) {
        self.homepageUseCase = homepageUseCase
    }
    
    func viewDidLoad(offset: Int) {
        stateVariable.accept(.loading)
        getPokemonList(offset: "\(offset)")
    }
}

extension HomepageViewModel {
    private func getPokemonList(offset: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self else { return }
            
            self.homepageUseCase.fetchPokemonList(offset: offset) { data, errorState in
                if let errorState = errorState {
                    switch errorState {
                    case .empty:
                        self.stateVariable.accept(.empty)
                    case .failed:
                        self.stateVariable.accept(.error)
                    }
                } else {
                    if let dataList = data {
                        self.stateVariable.accept(dataList.isEmpty ? .empty : .showContent(dataList))
                    } else {
                        self.stateVariable.accept(.empty)
                    }
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
