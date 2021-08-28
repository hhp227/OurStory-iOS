//
//  ContentView.swift
//  application
//
//  Created by 홍희표 on 2020/05/17.
//  Copyright © 2020 홍희표. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        switch viewModel.loginState {
        case .login:
            MainView(main: AnyView(LoungeView())).environmentObject(viewModel)
        case .logout:
            LoginView().environmentObject(viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init(LoginRepository(ApiServiceImpl())))
    }
}
