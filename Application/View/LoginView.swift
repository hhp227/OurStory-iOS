//
//  LoginView.swift
//  Application
//
//  Created by 홍희표 on 2021/08/28.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack {
            VStack {
                Text("Welcome!").font(.title)
                VStack(alignment: .leading) {
                    Text("Email")
                    TextField("Email", text: $viewModel.email).autocapitalization(.none).keyboardType(.emailAddress).disableAutocorrection(true).padding(10)
                    Text("Password")
                    SecureField("Password", text: $viewModel.password).padding(10)
                }.padding(10)
            }
            Button(action: viewModel.login) {
                Text("LOGIN").font(.system(size: 15, weight: .semibold)).frame(width: 200, alignment: .center).padding(12.5).background(RoundedRectangle(cornerRadius: 3).strokeBorder())
            }
            Button(action: { viewModel.isShowRegister = true }) {
                Text("Register").font(.system(size: 13)).padding(5)
            }.sheet(isPresented: $viewModel.isShowRegister) {
                RegisterView(viewModel: .init(RegisterRepository(ApiServiceImpl())))
            }
        }.padding(16)/*.background(NavigationLink(destination: MainView(main: AnyView(LoungeView())).environmentObject(viewModel), isActive: $viewModel.loginResult) {
        EmptyView()
    })*/
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
