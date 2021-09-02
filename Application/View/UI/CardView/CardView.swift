//
//  CardView.swift
//  Application
//
//  Created by 홍희표 on 2021/09/03.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct CardView: View {
    var postItem: PostItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hello, CardView id: \(postItem.id), userId: \(postItem.userId), text: \(postItem.text)").frame(minWidth: 0, maxWidth: .infinity)
        }.padding().cornerRadius(10).overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.5), lineWidth: 1)).padding([.leading, .trailing])
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(postItem: PostItem.init(id: 0, userId: 0, name: "Test", text: "TestText", status: 0, profileImage: nil, timeStamp: "2021.09.03", replyCount: 0, likeCount: 0, attachment: PostItem.Attachment.init(images: [], video: nil)))
    }
}
