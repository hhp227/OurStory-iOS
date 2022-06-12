//
//  ReplyListCell.swift
//  Application
//
//  Created by 홍희표 on 2022/06/04.
//  Copyright © 2022 홍희표. All rights reserved.
//

import SwiftUI

struct ReplyListCell: View {
    @State private var isNavigateUpdateReplyView = false
    
    @State private var isActionSheetVisible = false
    
    let reply: ReplyItem
    
    let onAction: ([String: Any]) -> Void
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack(alignment: .top) {
                AsyncImage(url: URL(string: URL_POST_IMAGE_PATH + (reply.profileImage ?? ""))!).frame(width: 55, height: 55).cornerRadius(45)
                VStack(alignment: .leading) {
                    Text(reply.name).fontWeight(.bold)
                    Text(reply.reply)
                }.padding(.leading, 7)
                Spacer()
            }.padding(.horizontal, 5)
            Text(DateUtil.getPeriodTimeGenerator(DateUtil.parseDate(reply.timeStamp))).font(.system(size: 14))
            NavigationLink(destination: UpdateReplyView(args: ["reply": reply], onResult: onAction), isActive: $isNavigateUpdateReplyView, label: { EmptyView() })
        }.padding(8).onLongPressGesture {
            isActionSheetVisible.toggle()
        }.actionSheet(isPresented: $isActionSheetVisible, content: getActionSheet)
    }
    
    func getActionSheet() -> ActionSheet {
        var buttons = [ActionSheet.Button]()
        
        buttons.append(.default(Text("Copy Content")) {
            UIPasteboard.general.string = reply.reply
        })
        if let user = UserDefaultsManager.instance.user, user.id == reply.userId {
            buttons.append(.default(Text("Edit Comment")) {
                isNavigateUpdateReplyView.toggle()
            })
            buttons.append(.destructive(Text("Delete Comment"), action: { onAction([:]) }))
        }
        buttons.append(.cancel())
        return ActionSheet(title: Text("Selection Action"), buttons: buttons)
    }
}

struct ReplyListCell_Previews: PreviewProvider {
    static var previews: some View {
        ReplyListCell(reply: ReplyItem.EMPTY, onAction: { _ in })
    }
}
