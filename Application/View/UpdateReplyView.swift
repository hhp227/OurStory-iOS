//
//  UpdateReplyView.swift
//  Application
//
//  Created by 홍희표 on 2021/10/04.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct UpdateReplyView: View {
    @ObservedObject var viewModel: UpdateReplyViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let onResult: ([String: ReplyItem]) -> Void
    
    var body: some View {
        List {
            ZStack {
                TextEditor(text: $viewModel.message).autocapitalization(.none).keyboardType(.default).disableAutocorrection(true)
                Text(viewModel.message).opacity(0).padding(.all, 8)
            }.listRowInsets(EdgeInsets()).shadow(radius: 1).onReceive(viewModel.$state) { state in
                if state.text != nil {
                    var reply = viewModel.reply // TODO viewModel에서 처리하는것으로 변경하기
                    reply.reply = state.text!
                    
                    onResult(["reply": reply])
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }.navigationBarItems(trailing: Button(action: viewModel.updateReply) { Text("Send") }).navigationBarTitleDisplayMode(.inline)
    }
    
    init(args: [String: Any], onResult: @escaping ([String: ReplyItem]) -> Void) {
        self.viewModel = InjectorUtils.instance.provideUpdateReplyViewModel(params: args)
        self.onResult = onResult
    }
}

struct UpdateReplyView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateReplyView(args: ["reply": ReplyItem.EMPTY], onResult: { _ in })
    }
}
