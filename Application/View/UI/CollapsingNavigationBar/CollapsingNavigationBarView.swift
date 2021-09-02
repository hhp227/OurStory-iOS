//
//  CollapsingNavigationBarView.swift
//  Application
//
//  Created by 홍희표 on 2021/08/16.
//

import SwiftUI

struct CollapsingNavigationBar<Header: View, Content: View>: View {
    @State var offset: CGFloat = 0
    
    let maxHeight = UIScreen.main.bounds.height / 2.5
    
    let scrollUpBehavior: ScrollUpHeaderBehavior
    
    let scrollDownBehavior: ScrollDownHeaderBehavior
    
    var header: () -> Header
    
    var content: () -> Content
    
    var body: some View {
        GeometryReader { globalProxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    GeometryReader { proxy in
                        header().opacity(getOpacity()).foregroundColor(.white).frame(maxWidth: .infinity).frame(height: getHeaderHeight(edgeInsets: globalProxy.safeAreaInsets), alignment: .bottom).background(Color.red)
                    }.frame(height: maxHeight).offset(y: -offset).zIndex(1)
                    content().zIndex(0)
                }.modifier(OffsetModifier(offset: $offset))
            }.coordinateSpace(name: "SCROLL")
        }
    }
    
    func getHeaderHeight(edgeInsets: EdgeInsets) -> CGFloat {
        let topHeight = maxHeight + offset
        return scrollUpBehavior == .parallax ? (topHeight > /*80 + */edgeInsets.top ? topHeight : /*80 + */edgeInsets.top) : (topHeight > maxHeight ? maxHeight : topHeight)
        //return topHeight > /*80 + */edgeInsets.top ? topHeight : /*80 + */edgeInsets.top
    }
    
    func topAppBarTitleOpacity(edgeInsets: EdgeInsets) -> Double {
        let progress = -(offset + 60) / (maxHeight - (/*80 + */edgeInsets.top))
        return Double(progress)
    }
    
    func getOpacity() -> Double {
        let progress = -(offset + 100) / 70
        let opacity = 1 - progress
        return Double(offset < 0 ? opacity : 1)
    }
}

public enum ScrollUpHeaderBehavior {
    case parallax
    case sticky
}

public enum ScrollDownHeaderBehavior {
    case offset
    case sticky
}

struct OffsetModifier: ViewModifier {
    @Binding var offset: CGFloat
    
    func body(content: Content) -> some View {
        content.overlay(GeometryReader { proxy -> Color in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            
            DispatchQueue.main.async {
                offset = minY
            }
            return Color.clear
        }, alignment: .center)
    }
}
