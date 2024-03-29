//
//  PagerTabView.swift
//  Application
//
//  Created by hhp227 on 2023/06/02.
//

import SwiftUI

struct PagerTabView<Content: View, Label: View>: View {
    @State
    var offset: CGFloat = 0
    
    @State
    var maxTabs: CGFloat = 0
    
    @State
    var tabOffset: CGFloat = 0
    
    @Binding
    var selection: Int
    
    var content: Content
    
    var label: Label
    
    var tint: Color
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                label
            }
            .overlay {
                HStack(spacing: 0) {
                    ForEach(0..<Int(maxTabs), id: \.self) { index in
                        Rectangle()
                            .fill(Color.black.opacity(0.01))
                            .onTapGesture {
                                let newOffset = CGFloat(index) * getScreenBounds().width
                                self.offset = newOffset
                            }
                    }
                }
            }
            .foregroundColor(tint)
            Capsule()
                .fill(tint)
                .frame(width: maxTabs == 0 ? 0 : (getScreenBounds().width / maxTabs), height: 5)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(x: tabOffset)
            OffsetPageTabView(selection: $selection, offset: $offset) {
                HStack(spacing: 0) {
                    content
                }
                .overlay(GeometryReader { proxy in
                    Color.clear
                        .preference(key: TabPreferenceKey.self, value: proxy.frame(in: .global))
                })
                .onPreferenceChange(TabPreferenceKey.self) { proxy in
                    let minX = -proxy.minX
                    let maxWidth = proxy.width
                    let screenWidth = getScreenBounds().width
                    let maxTabs = (maxWidth / screenWidth).rounded()
                    let progress = minX / screenWidth
                    let tabOffset = progress * (screenWidth / maxTabs)
                    self.tabOffset = tabOffset
                    self.maxTabs = maxTabs
                }
            }
        }
    }
    
    init(
        tint: Color,
        selection: Binding<Int>,
        @ViewBuilder labels: @escaping () -> Label,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content()
        self.label = labels()
        self.tint = tint
        self._selection = selection
    }
}

struct TabPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .init()
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    func pageView(ignoresSafeArea: Bool = false, edges: Edge.Set = []) -> some View {
        self.frame(width: getScreenBounds().width, alignment: .center)
            .ignoresSafeArea(ignoresSafeArea ? .container : .init(), edges: edges)
    }
    
    func getScreenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}
