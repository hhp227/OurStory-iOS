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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct GroupGridCell_Previews: PreviewProvider {
    static var previews: some View {
        GroupGridCell(group: .init(id: 0, authorId: 0, joinType: 0))
    }
}
