//
//  ContentView.swift
//  application
//
//  Created by 홍희표 on 2020/05/17.
//  Copyright © 2020 홍희표. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        NavigationView {
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
                Button(action: viewModel.loginTest) {
                    Text("LOGIN").font(.system(size: 15, weight: .semibold)).frame(width: 200, alignment: .center).padding(12.5).background(RoundedRectangle(cornerRadius: 3).strokeBorder())
                }
                NavigationLink(destination: RegisterView(viewModel: .init(RegisterRepository()))) {
                    Text("Register").font(.system(size: 13)).padding(5)
                }
            }.padding(16).navigationBarHidden(true).background(NavigationLink(destination: MainView(), isActive: $viewModel.loginResult) {
                EmptyView()
            })/*.onReceive(viewModel.$loginResult) { result in
                print(result)
            }*/
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: .init(LoginRepository()))
    }
}
