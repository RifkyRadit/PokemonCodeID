//
//  LoginViewModel.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import Foundation
import RxSwift
import RxRelay

enum LoginResult {
    case successLogin
    case userNotFound
    case wrongPassword
}

enum LoginViewState {
    case loading
    case loginResult(_ state: LoginResult)
}

protocol LoginViewModelType {
    var inputs: LoginViewModelInput { get }
    var outputs: LoginViewModelOutput { get }
}

protocol LoginViewModelInput {
    func loginUser(username: String, password: String)
}

protocol LoginViewModelOutput {
    var state: Observable<LoginViewState?> { get }
}

final class LoginViewModel: LoginViewModelInput {
    
    private var loginUseCase: LoginUseCaseProtocol
    
    private var stateVariable = BehaviorRelay<LoginViewState?>(value: nil)
    
    init(loginUseCase: LoginUseCaseProtocol = LoginUseCaseImpl()) {
        self.loginUseCase = loginUseCase
    }
    
    func loginUser(username: String, password: String) {
        stateVariable.accept(.loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self else { return }
            
            let resultLogin = self.loginUseCase.userLogin(username: username, password: password)
            self.stateVariable.accept(.loginResult(resultLogin))
        }
    }
}

extension LoginViewModel: LoginViewModelType {
    var inputs: LoginViewModelInput { return self }
    var outputs: LoginViewModelOutput { return self }
}

extension LoginViewModel: LoginViewModelOutput {
    var state: Observable<LoginViewState?> {
        return stateVariable.asObservable()
    }
}
