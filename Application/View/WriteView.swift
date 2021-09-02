//
//  WriteView.swift
//  Application
//
//  Created by 홍희표 on 2021/08/08.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct WriteView: View {
    @EnvironmentObject var viewModel: WriteViewModel
    
    var body: some View {
        List {
            ZStack {
                TextEditor(text: $viewModel.text)
                Text(viewModel.text).opacity(0).padding(.all, 8)
            }.shadow(radius: 1)
        }
    }
}

struct WriteView_Previews: PreviewProvider {
    static var previews: some View {
        WriteView()
    }
}
