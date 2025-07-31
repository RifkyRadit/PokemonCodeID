//
//  RegisterViewModel.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 30/07/25.
//

import Foundation
import RxSwift
import RxRelay

enum RegisterViewState {
    case loading
    case successRegistration
    case failedRegistration
    case invalidData(state: RegisterValidationState)
}

protocol RegisterViewModelType {
    var inputs: RegisterViewModelInput { get }
    var outputs: RegisterViewModelOutput { get }
}

protocol RegisterViewModelInput {
    func registerNewUser(email: String, username: String, password: String, confirmPassword: String)
}

protocol RegisterViewModelOutput {
    var state: Observable<RegisterViewState?> { get }
}

final class RegisterViewModel: RegisterViewModelInput {
    private var registerUseCase: RegisterUseCaseProtocol
    
    private var stateVariable = BehaviorRelay<RegisterViewState?>(value: nil)
    
    init(registerUseCase: RegisterUseCaseProtocol = RegisterUseCaseImpl()) {
        self.registerUseCase = registerUseCase
    }
    
    func registerNewUser(email: String, username: String, password: String, confirmPassword: String) {
        validationDataUser(email: email, username: username, password: password, confirmPassword: confirmPassword)
    }
}

extension RegisterViewModel: RegisterViewModelType {
    var inputs: RegisterViewModelInput { return self }
    var outputs: RegisterViewModelOutput { return self }
}

extension RegisterViewModel {
    private func validationDataUser(email: String, username: String, password: String, confirmPassword: String) {
        stateVariable.accept(.loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self else { return }
            
            let validationData = self.registerUseCase.validateUserProfile(username: username, email: email, password: password, confirmPassword: confirmPassword)
            switch validationData {
            case .success:
                self.registerUser(email: email, username: username, password: password)
            case .usernameAlready:
                self.stateVariable.accept(.invalidData(state: .usernameAlready))
            case .emailAlready:
                self.stateVariable.accept(.invalidData(state: .emailAlready))
            case .passowrdNotSame:
                self.stateVariable.accept(.invalidData(state: .passowrdNotSame))
            }
        }
    }
    
    private func registerUser(email: String, username: String, password: String) {
        registerUseCase.registerUser(username: username, email: email, password: password) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.stateVariable.accept(.successRegistration)
            case .failure:
                self.stateVariable.accept(.failedRegistration)
            }
        }
    }
}

extension RegisterViewModel: RegisterViewModelOutput {
    var state: Observable<RegisterViewState?> {
        return stateVariable.asObservable()
    }
}
