//
//  PostDetailView.swift
//  Application
//
//  Created by 홍희표 on 2021/07/24.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct PostDetailView: View {
    @ObservedObject var viewModel: PostDetailViewModel = PostDetailViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                Section(header: EmptyView()) {
                    Text("Content")
                }
                ForEach(0..<100) { i in
                    Text("Item \(i)")
                }
            }
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 5) {
                    TextField("Add a Comment", text: $viewModel.message).padding(10)
                    Button(action: viewModel.actionSend) {
                        Text("Send").foregroundColor(.gray).padding(10).overlay(RoundedRectangle(cornerRadius: 2).stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.5), lineWidth: 1))
                    }
                }.padding(5)
            }
        }
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView()
    }
}
