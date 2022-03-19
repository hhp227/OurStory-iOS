//
//  ContentView.swift
//  application
//
//  Created by 홍희표 on 2020/05/17.
//  Copyright © 2020 홍희표. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: LoginViewModel = InjectorUtils.instance.provideLoginViewModel()
    
    var body: some View {
        if InjectorUtils.instance.getUserDefaultsManager().user != nil {
            MainView()
        } else {
            LoginView().environmentObject(viewModel).animation(.easeIn)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
