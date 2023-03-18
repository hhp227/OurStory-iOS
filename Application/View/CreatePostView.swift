//
//  CreatePostView.swift
//  Application
//
//  Created by 홍희표 on 2021/08/08.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI
import PhotosUI

struct CreatePostView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @State private var isShowingActionSheet = false
    
    @State private var isShowingImagePicker = false
    
    @State private var selectedItems: [PhotosPickerItem] = []
    
    @StateObject var viewModel = InjectorUtils.instance.provideCreatePostViewModel()
    
    let onResult: () -> Void
    
    var body: some View {
        List {
            ZStack {
                TextEditor(text: $viewModel.state.text).autocapitalization(.none).keyboardType(.default).disableAutocorrection(true)
                Text(viewModel.state.text).opacity(0).padding(.all, 8)
            }.listRowInsets(EdgeInsets()).shadow(radius: 1)
        }.navigationBarTitleDisplayMode(.inline).navigationBarItems(trailing: Button(action: { viewModel.actionSend(viewModel.state.text, items: viewModel.state.items) }) { Text("Send") })
        VStack(alignment: .leading, spacing: 0) {
            Divider()
            HStack(spacing: 5) {
                Button(action: { isShowingActionSheet.toggle() }) {
                    Image(systemName: "photo.fill").padding(10)
                }
                Button(action: {}) {
                    Image(systemName: "video.fill").padding(10)
                }
            }.padding(5)
        }.actionSheet(isPresented: $isShowingActionSheet) {
            ActionSheet(title: Text("Selection Action"), buttons: [
                .default(Text("Gallery")) {
                    isShowingImagePicker.toggle()
                },
                .default(Text("Camera")),
                .cancel()
            ])
        }.photosPicker(isPresented: $isShowingImagePicker, selection: $selectedItems, matching: .images).onReceive(viewModel.$state) { state in
            if state.postId >= 0 {
                onResult()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView(onResult: {})
    }
}
