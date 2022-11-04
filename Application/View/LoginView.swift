//
//  LoginView.swift
//  Application
//
//  Created by 홍희표 on 2021/08/28.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel = InjectorUtils.instance.provideLoginViewModel()
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
