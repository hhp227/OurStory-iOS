//
//  RegisterView.swift
//  Application
//
//  Created by 홍희표 on 2021/07/29.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    @State var name: String = ""
    
    @State var email: String = ""
    
    @State var password: String = ""
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Name")
                TextField("Name", text: $name).padding(10)
                Text("Email")
                TextField("Email", text: $email).padding(10)
                Text("Password")
                SecureField("Password", text: $password).padding(10)
            }.padding(10)
            Button(action: actionRegister) {
                Text("REGISTER").font(.system(size: 15, weight: .semibold)).frame(width: 200, alignment: .center).padding(12.5).background(RoundedRectangle(cornerRadius: 3).strokeBorder())
            }
        }.padding(16)
    }
    
    func actionRegister() {
        
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
