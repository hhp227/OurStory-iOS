//
//  RegisterView.swift
//  Application
//
//  Created by 홍희표 on 2021/07/29.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: RegisterViewModel = InjectorUtils.instance.provideRegisterViewModel()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Name")
                TextField("Name", text: $viewModel.name).padding(10)
                Text("Email")
                TextField("Email", text: $viewModel.email).autocapitalization(.none).keyboardType(.emailAddress).disableAutocorrection(true).padding(10)
                Text("Password")
                SecureField("Password", text: $viewModel.password).padding(10)
            }.padding(10)
            Button(action: viewModel.register) {
                Text("REGISTER").font(.system(size: 15, weight: .semibold)).frame(width: 200, alignment: .center).padding(12.5).background(RoundedRectangle(cornerRadius: 3).strokeBorder())
            }
        }.padding(16).onReceive(viewModel.$registerResult) { isRegistered in
            if isRegistered {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
