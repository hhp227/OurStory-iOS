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
    
    var body: some View {
        List {
            ZStack {
                TextEditor(text: $viewModel.message).autocapitalization(.none).keyboardType(.default).disableAutocorrection(true)
                Text(viewModel.message).opacity(0).padding(.all, 8)
            }.listRowInsets(EdgeInsets()).shadow(radius: 1)
        }.navigationBarItems(trailing: Button(action: viewModel.updateReply) { Text("Send") }).navigationBarTitleDisplayMode(.inline)
    }
    
    init(args: [String: Any]) {
        self.viewModel = InjectorUtils.instance.provideUpdateReplyViewModel(params: args)
    }
}

struct UpdateReplyView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateReplyView(args: ["reply": ReplyItem.init(id: 0, userId: 0, name: "hhp227", reply: "hi temp", status: 0, timeStamp: "")])
    }
}
