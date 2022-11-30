//
//  PostDetailView.swift
//  Application
//
//  Created by 홍희표 on 2021/07/24.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct PostDetailView: View {
    @ObservedObject var viewModel = InjectorUtils.instance.providePostDetailViewModel()
    
    let onResult: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, PostDetailView!")
        }
        .padding()
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(onResult: {})
    }
}
