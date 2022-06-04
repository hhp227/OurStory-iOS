//
//  CreatePostView.swift
//  Application
//
//  Created by 홍희표 on 2021/08/08.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct CreatePostView: View {
    // TODO @StateObject로 교체
    @ObservedObject var viewModel: CreatePostViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let onResult: () -> Void
    
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
                Button(action: { viewModel.isShowingActionSheet.toggle() }) {
                    Image(systemName: "photo.fill").padding(10)
                }
                Button(action: {}) {
                    Image(systemName: "video.fill").padding(10)
                }
            }.padding(5)
        }.actionSheet(isPresented: $viewModel.isShowingActionSheet) {
            ActionSheet(title: Text("Selection Action"), buttons: [
                .default(Text("Gallery")) {},
                .default(Text("Camera")),
                .cancel()
            ])
        }.onReceive(viewModel.$state) { state in
            if state.postId >= 0 {
                onResult()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    init(args: [String: Any], onResult: @escaping () -> Void) {
        self.viewModel = InjectorUtils.instance.provideCreatePostViewModel(params: args)
        self.onResult = onResult
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView(args: ["group_id": 0], onResult: {})
    }
}
