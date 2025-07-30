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
    private var registerUseCase = RegisterUseCaseImpl()
    
    private var stateVariable = BehaviorRelay<RegisterViewState?>(value: nil)
    
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
        let validationData = registerUseCase.validateUserProfile(username: username, email: email, password: password, confirmPassword: confirmPassword)
        switch validationData {
        case .success:
            registerUser(email: email, username: username, password: password)
        case .usernameAlready:
            stateVariable.accept(.invalidData(state: .usernameAlready))
        case .emailAlready:
            stateVariable.accept(.invalidData(state: .emailAlready))
        case .passowrdNotSame:
            stateVariable.accept(.invalidData(state: .passowrdNotSame))
        }
    }
    
    private func registerUser(email: String, username: String, password: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            
            self.registerUseCase.registerUser(username: username, email: email, password: password) { result in
                switch result {
                case .success:
                    print(">>> DEBUG registerUser success")
                    self.stateVariable.accept(.successRegistration)
                case .failure:
                    print(">>> DEBUG registerUser failed")
                    self.stateVariable.accept(.failedRegistration)
                }
            }
        }
    }
}

extension RegisterViewModel: RegisterViewModelOutput {
    var state: Observable<RegisterViewState?> {
        return stateVariable.asObservable()
    }
}
