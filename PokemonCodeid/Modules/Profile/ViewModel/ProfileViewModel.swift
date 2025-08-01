//
//  ProfileViewModel.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation
import RxSwift
import RxRelay

enum ProfileViewState {
    case loading
    case showContent(_ data: UserModel)
}

protocol ProfileViewModelType {
    var inputs: ProfileViewModelInput { get }
    var outputs: ProfileViewModelOutput { get }
}

protocol ProfileViewModelInput {
    func viewDidLoad()
}

protocol ProfileViewModelOutput {
    var state: Observable<ProfileViewState?> { get }
}

final class ProfileViewModel: ProfileViewModelInput {
    
    private var profileUseCase: ProfileUseCaseProtocol
    
    private var stateVariable = BehaviorRelay<ProfileViewState?>(value: nil)
    
    init(profileUseCase: ProfileUseCaseProtocol = ProfileUseCaseImpl()) {
        self.profileUseCase = profileUseCase
    }
    
    func viewDidLoad() {
        stateVariable.accept(.loading)
        fetchUserProfile()
    }
}

extension ProfileViewModel {
    private func fetchUserProfile() {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.5) { [weak self] in
            guard let self else { return }
            let username = UserDefaults.standard.string(forKey: "usernameProfile") ?? ""
            guard let dataUser = self.profileUseCase.fetchUserProfile(username: username) else {
                return
            }
            
            stateVariable.accept(.showContent(dataUser))
        }
    }
}

extension ProfileViewModel: ProfileViewModelType {
    var inputs: ProfileViewModelInput { return self }
    var outputs: ProfileViewModelOutput { return self }
}

extension ProfileViewModel: ProfileViewModelOutput {
    var state: Observable<ProfileViewState?> {
        return stateVariable.asObservable()
    }
}
