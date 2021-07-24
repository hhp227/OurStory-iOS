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
        VStack(alignment: .leading) {
            Text("Email")
            TextField("Enter your name", text: $email)
            Text("Password")
            TextField("Enter your password", text: $password)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
