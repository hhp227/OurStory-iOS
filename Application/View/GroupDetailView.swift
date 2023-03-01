//
//  GroupDetailView.swift
//  Application
//
//  Created by 홍희표 on 2021/08/15.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct GroupDetailView: View {
    @State var selectedTab: String = "square.grid.3x3"

    @Namespace var animation

    @Environment(\.colorScheme) var scheme

    @State var topHeaderOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack {
                    Divider()
                    HStack(spacing: 10) {
                        Button(action: {}, label: {
                            Text("Edit Profile").fontWeight(.semibold).foregroundColor(.primary).padding(.vertical, 10).frame(maxWidth: .infinity).background(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
                        })
                        Button(action: {}, label: {
                            Text("Promotion's").fontWeight(.semibold).foregroundColor(.primary).padding(.vertical, 10).frame(maxWidth: .infinity).background(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
                        })
                    }.padding([.horizontal, .top])
                    // Stories Sections...
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        HStack(spacing: 15) {
                            Button(action: {}, label: {
                                VStack {
                                    Image(systemName: "plus").font(.title2).foregroundColor(.primary).padding(18).background(Circle().stroke(Color.gray))
                                    Text("New").foregroundColor(.primary)
                                }
                            })
                        }.padding([.horizontal, .top])
                    })
                    GeometryReader { proxy -> AnyView in
                        let minY = proxy.frame(in: .global).minY
                        let offset = minY - topHeaderOffset
                        return AnyView(
                            // Sticky Top Segmented Bar...
                            HStack(spacing: 0) {
                                TabBarButton(image: "square.grid.3x3", isSystemImage: true, animation: animation, selectedTab: $selectedTab)
                                TabBarButton(image: "reels", isSystemImage: true, animation: animation, selectedTab: $selectedTab)
                                TabBarButton(image: "person.crop.square", isSystemImage: true, animation: animation, selectedTab: $selectedTab)
                            }.frame(height: 70, alignment: .bottom).background(scheme == .dark ? Color.black : Color.white).offset(y: offset < 0 ? -offset : 0)
                        )
                    }.frame(height: 70).zIndex(4)
                    ZStack {
                        LazyVStack {
                            ForEach(1...20, id: \.self) { index in
                                GeometryReader { proxy in
                                    let width = proxy.frame(in: .global).width
                                    
                                    ImageView(index: index, width: width)
                                }.frame(height: 120)
                            }
                        }
                    }
                }
            })
        }
    }
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView()
    }
}

struct ImageView: View {
    var index: Int

    var width: CGFloat

    var body: some View {
        VStack {
            let imageName = index > 10 ? index - (10 * (index / 10)) == 0 ? 10 : index - (10 * (index / 10)) : index
        
            Image("image\(imageName)").resizable().aspectRatio(contentMode: .fill).frame(width: width, height: 120).cornerRadius(0)
        }
    }
}

struct TabBarButton: View {
    var image: String

    var isSystemImage: Bool

    var animation: Namespace.ID

    @Binding var selectedTab: String

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                selectedTab = image
            }
        }, label: {
            VStack(spacing: 12) {
                (isSystemImage ? Image(systemName: image) : Image(image)).renderingMode(.template).resizable().aspectRatio(contentMode: .fit).frame(width: 28, height: 28).foregroundColor(selectedTab == image ? .primary : .gray)
                ZStack {
                    if selectedTab == image {
                        Rectangle().fill(Color.primary).matchedGeometryEffect(id: "TAB", in: animation)
                    } else {
                        Rectangle().fill(Color.clear)
                    }
                }.frame(height: 1)
            }
        })
    }
}
