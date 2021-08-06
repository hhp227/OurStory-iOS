//
//  ContentView.swift
//  application
//
//  Created by 홍희표 on 2020/05/17.
//  Copyright © 2020 홍희표. All rights reserved.
//

import SwiftUI
import Alamofire

struct LoginView: View {
    @State var email: String = ""
    
    @State var password: String = ""
    
    var body: some View {
        NavigationView {
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
                NavigationLink(destination: RegisterView()) {
                    Text("Register").font(.system(size: 13)).padding(5)
                }
            }.padding(16).navigationBarHidden(true)
        }
    }
    
    func actionLogin() {
        if !email.isEmpty && !password.isEmpty {
            AF.request(URL_LOGIN, method: .post, parameters: ["email": email, "password": password]).responseJSON { response in
                switch response.result {
                case .success(let data):
                    print(data)
                    break
                case .failure(_):
                    print("fail")
                    break
                }
            }
        } else {
            print("email 또는 password가 잘못되었습니다.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
