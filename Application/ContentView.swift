//
//  ContentView.swift
//  application
//
//  Created by 홍희표 on 2020/05/17.
//  Copyright © 2020 홍희표. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var email: String = ""
    
    @State var password: String = ""
    
    var body: some View {
        VStack {
            VStack {
                Text("Welcome!").font(.title)
                VStack(alignment: .leading) {
                    Text("Email")
                    TextField("Email", text: $email).padding(10)
                    Text("Password")
                    SecureField("Password", text: $password).padding(10)
                }.padding(10)
            }
            Button(action: actionLogin) {
                Text("LOGIN").font(.system(size: 15, weight: .semibold)).frame(width: 200, alignment: .center).padding(12.5).background(RoundedRectangle(cornerRadius: 3).strokeBorder())
            }
            Button(action: actionRegister) {
                Text("Register").font(.system(size: 13)).padding(5)
            }
        }.padding(16)
    }
    
    func actionLogin() {
        print("email: \(email), password: \(password)")
    }
    
    func actionRegister() {
        print("action register")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
