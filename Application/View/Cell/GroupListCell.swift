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
        Text("Hello, \(group.id)")
    }
}

struct GroupListCell_Previews: PreviewProvider {
    static var previews: some View {
        GroupListCell(group: .init(id: 0, authorId: 0, joinType: 0))
    }
}
