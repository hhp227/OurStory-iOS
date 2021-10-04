//
//  ReplyModifyView.swift
//  Application
//
//  Created by 홍희표 on 2021/10/04.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct ReplyModifyView: View {
    @EnvironmentObject var viewModel: PostDetailViewModel
    
    var body: some View {
        Text("Hello, ReplyModifyView!")
    }
}

struct ReplyModifyView_Previews: PreviewProvider {
    static var previews: some View {
        ReplyModifyView()
    }
}
