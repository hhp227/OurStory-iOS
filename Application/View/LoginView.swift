//
//  LoginView.swift
//  Application
//
//  Created by 홍희표 on 2021/08/28.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    //@EnvironmentObject var viewModel: LoginViewModel
    @ObservedObject var viewModel: LoginViewModel = InjectorUtils.instance.provideLoginViewModel()
    
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
            Button(action: { viewModel.isShowRegister.toggle() }) {
                Text("Register").font(.system(size: 13)).padding(5)
            }.sheet(isPresented: $viewModel.isShowRegister) {
                RegisterView()
            }
        }.padding(16).onReceive(viewModel.$state) { state in
            if let user = state.user {
                viewModel.storeUser(user)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
