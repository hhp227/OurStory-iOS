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
        if let user = UserDefaults.standard.value(forKey: "user") {
            MainView().environmentObject(viewModel)/*.onAppear {
                print("user: \(try! JSONDecoder().decode(User.self, from: user as! Data))")
            }*/
        } else {
            LoginView().environmentObject(viewModel).animation(.easeIn)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init(UserRepository(ApiServiceImpl())))
    }
}
