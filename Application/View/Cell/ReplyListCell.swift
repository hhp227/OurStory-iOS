//
//  ReplyListCell.swift
//  Application
//
//  Created by 홍희표 on 2022/06/04.
//  Copyright © 2022 홍희표. All rights reserved.
//

import SwiftUI

struct ReplyListCell: View {
    let reply: ReplyItem
    
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
        }.padding(8)
    }
}

struct ReplyListCell_Previews: PreviewProvider {
    static var previews: some View {
        ReplyListCell(reply: ReplyItem.EMPTY)
    }
}
