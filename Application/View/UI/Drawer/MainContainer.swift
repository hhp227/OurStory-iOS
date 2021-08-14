//
//  MainContainer.swift
//  Application
//
//  Created by 홍희표 on 2021/08/12.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI
import Combine

struct MainContainer<Content: View>: View {
    @ObservedObject private var drawerControl: DrawerViewModel
    
    @State private var gestureCurrent: CGFloat = 0
    
    private var maxMaskAlpha: CGFloat
    
    private var maskEnable: Bool
    
    let main: AnyView
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                self.main
                if maskEnable {
                    Color.black.opacity(Double(drawerControl.maxShowRate * self.maxMaskAlpha)).animation(.easeIn(duration: 0.15)).onTapGesture {
                        self.drawerControl.hideAllSlider()
                    }.padding(EdgeInsets(top: -proxy.safeAreaInsets.top, leading: 0, bottom: -proxy.safeAreaInsets.bottom, trailing: 0))
                }
            }.gesture(DragGesture().onEnded { value in
                self.gestureCurrent = 0
            })
        }.animation(.default)
    }
    
    init(content: Content, maxMaskAlpha: CGFloat = 0.25, maskEnable: Bool = true, drawerControl: DrawerViewModel) {
        self.main = AnyView.init(content.environmentObject(drawerControl))
        self.maxMaskAlpha = maxMaskAlpha
        self.maskEnable = maskEnable
        self.drawerControl = drawerControl
    }
}
