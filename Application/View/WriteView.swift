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
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        List {
            ZStack {
                TextEditor(text: $viewModel.text).autocapitalization(.none).keyboardType(.default).disableAutocorrection(true)
                Text(viewModel.text).opacity(0).padding(.all, 8)
            }.listRowInsets(EdgeInsets()).shadow(radius: 1)
        }.navigationBarTitleDisplayMode(.inline).navigationBarItems(trailing: Button(action: viewModel.actionSend) { Text("Send") })
        VStack(alignment: .leading, spacing: 0) {
            Divider()
            HStack(spacing: 5) {
                Button(action: {}) {
                    Image(systemName: "photo.fill").padding(10)
                }
                Button(action: {}) {
                    Image(systemName: "video.fill").padding(10)
                }
            }.padding(5)
        }.onReceive(viewModel.$sendResult) { isSent in
            if isSent {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct WriteView_Previews: PreviewProvider {
    static var previews: some View {
        WriteView()
    }
}
