//
//  CreatePostView.swift
//  Application
//
//  Created by 홍희표 on 2021/08/08.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct CreatePostView: View {
    @StateObject var viewModel = InjectorUtils.instance.provideCreatePostViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
    }
}
