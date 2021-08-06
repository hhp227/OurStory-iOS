//
//  TestView.swift
//  Application
//
//  Created by 홍희표 on 2021/07/24.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct TestView: View {
    @State private var text = ""
    
    var body: some View {
        List {
            Text("Enter the message")
            ZStack {
                TextEditor(text: $text)
                Text(text).opacity(0).padding(.all, 8)
            }.shadow(radius: 1)
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
