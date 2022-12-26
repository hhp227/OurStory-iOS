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
    @Published var email: String = ""
    
    @Published var password: String = ""
    
    @Published var state: State = State()
    
    @Published var isShowRegister = false
    
    private let repository: UserRepository
    
    private let userDefaultsManager: UserDefaultsManager
    
    private var subscriptions = Set<AnyCancellable>()
    
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
    
    func login() {
        if isEmailValid(email) && isPasswordValid(password) {
            repository.login(email, password)
                .receive(on: RunLoop.main)
                .sink { result in
                    switch result.status {
                    case .SUCCESS:
                        self.state = State(user: result.data)
                    case .ERROR:
                        self.state = State(error: result.message ?? "An unexpected error occured")
                    case .LOADING:
                        self.state = State(isLoading: true)
                    }
                }
                .store(in: &subscriptions)
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
        subscriptions.removeAll()
    }
    
    struct State {
        var isLoading: Bool = false
        
        var user: User? = nil
        
        var error: String = ""
    }
}
