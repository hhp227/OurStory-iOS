//
//  LoginViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/08/07.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var state: State = State()
    
    private let repository: UserRepository
    
    private let userDefaultsManager: UserDefaultsManager
    
    private func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return email.contains("@") ? NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email) : !email.isEmpty
    }
    
    private func isPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
    
    func storeUser(_ user: User) {
        userDefaultsManager.storeUser(user)
    }
    
    func login(_ email: String, _ password: String) {
        if isEmailValid(email) && isPasswordValid(password) {
            repository.login(email, password)
                .receive(on: RunLoop.main)
                .sink { result in
                    switch result.status {
                    case .SUCCESS:
                        self.state = self.state.copy(
                            isLoading: false,
                            user: result.data
                        )
                    case .ERROR:
                        self.state = self.state.copy(
                            isLoading: false,
                            error: result.message ?? "An unexpected error occured"
                        )
                    case .LOADING:
                        self.state = self.state.copy(
                            isLoading: true,
                            error: ""
                        )
                    }
                }
                .store(in: &state.subscriptions)
        } else {
            print("email 또는 password가 잘못되었습니다.")
        }
    }
    
    func showSnackBar() {
        print("error: \(state.error)")
    }
    
    init(_ repository: UserRepository, _ userDefaultsManager: UserDefaultsManager) {
        self.repository = repository
        self.userDefaultsManager = userDefaultsManager
    }
    
    deinit {
        state.subscriptions.removeAll()
    }
    
    struct State {
        var email: String = ""
        
        var password: String = ""
        
        var isLoading: Bool = false
        
        var user: User? = nil
        
        var error: String = ""
        
        var subscriptions: Set<AnyCancellable> = []
    }
}

extension LoginViewModel.State {
    func copy(
        email: String? = nil,
        password: String? = nil,
        isLoading: Bool? = nil,
        user: User? = nil,
        error: String? = nil,
        subscriptions: Set<AnyCancellable>? = nil
    ) -> LoginViewModel.State {
        return .init(
            email: email ?? self.email,
            password: password ?? self.password,
            isLoading: isLoading ?? self.isLoading,
            user: user ?? self.user,
            error: error ?? self.error,
            subscriptions: subscriptions ?? self.subscriptions
        )
    }
}
