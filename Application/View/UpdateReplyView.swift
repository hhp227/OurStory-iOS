//
//  UpdateReplyView.swift
//  Application
//
//  Created by 홍희표 on 2021/10/04.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct UpdateReplyView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @StateObject private var viewModel: UpdateReplyViewModel = InjectorUtils.proviteUpdateReplyViewModel(InjectorUtils.instance)()
    
    let onResult: () -> Void
    
    var body: some View {
        List {
            ZStack {
                TextEditor(text: $viewModel.state.text).autocapitalization(.none).keyboardType(.default).disableAutocorrection(true)
                Text(viewModel.state.text).opacity(0).padding(.all, 8)
            }.listRowInsets(EdgeInsets()).shadow(radius: 1)/*.onReceive(viewModel.$state) { state in
                if state.text != nil {
                    var reply = viewModel.reply // TODO viewModel에서 처리하는것으로 변경하기
                    reply.reply = state.text
                    
                    onResult()
                    presentationMode.wrappedValue.dismiss()
                }
            }*/
        }.navigationBarItems(trailing: Button(action: viewModel.updateReply) { Text("Send") }).navigationBarTitleDisplayMode(.inline)
    }
}

struct UpdateReplyView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateReplyView(onResult: {})
    }
}
