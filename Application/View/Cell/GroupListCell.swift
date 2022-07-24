//
//  GroupListCell.swift
//  Application
//
//  Created by 홍희표 on 2022/05/11.
//  Copyright © 2022 홍희표. All rights reserved.
//

import SwiftUI

struct GroupListCell: View {
    let group: GroupItem
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: URL_GROUP_IMAGE_PATH + (group.image ?? ""))!) { result in
                switch result {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .failure:
                    Image(systemName: "photo")
                case .empty:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }.frame(width: 150, height: 100)
            VStack(alignment: .leading, spacing: 0) {
                Text(group.groupName ?? "Unknown GroupName")
                Text(group.description ?? "Unknown GroupDescruption")
            }
        }
    }
}

struct GroupListCell_Previews: PreviewProvider {
    static var previews: some View {
        GroupListCell(group: .init(id: 0, authorId: 0, joinType: 0))
    }
}
