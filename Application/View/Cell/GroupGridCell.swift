//
//  GroupGridCell.swift
//  Application
//
//  Created by 홍희표 on 2022/05/11.
//  Copyright © 2022 홍희표. All rights reserved.
//

import SwiftUI

struct GroupGridCell: View {
    let group: GroupItem
    
    var body: some View {
        NavigationLink(destination: GroupDetailView()) {
            CardView {
                VStack {
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
                    }
                    Text("Group \(group.id)")
                }
            }.frame(height: 120)
        }
    }
}

struct GroupGridCell_Previews: PreviewProvider {
    static var previews: some View {
        GroupGridCell(group: .init(id: 0, authorId: 0, groupName: "임시", authorName: "hhp227", image: nil, description: nil, createdAt: nil, joinType: 0))
    }
}
