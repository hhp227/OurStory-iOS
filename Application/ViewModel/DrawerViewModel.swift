//
//  DrawerViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/08/12.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

public class DrawerViewModel: ObservableObject {
    @Published private(set) var drawerView = [DrawerType: AnyView]()
    
    @Published private(set) var main: AnyView?
    
    @Published private(set) var maxShowRate: CGFloat = .zero
    
    private var statusObserver = [AnyCancellable]()
    
    private(set) var status = [DrawerType: DrawerStatus]() {
        didSet {
            statusObserver.forEach { $0.cancel() }
            statusObserver.removeAll()
            status.forEach { info in
                let observer = info.value.objectDidChange.sink { [weak self] s in
                    let maxRate = self?.status.sorted { (s0, s1) -> Bool in
                        s0.value.showRate > s1.value.showRate
                    }.first?.value.showRate ?? 0
                    
                    if self?.maxShowRate == maxRate {
                        return
                    }
                    self?.maxShowRate = maxRate
                }
                
                statusObserver.append(observer)
            }
        }
    }
    
    public func setDrawer<V: DrawerViewProtocol>(view: V, widthType: DrawerWidth = .percent(rate: 0.6), shadowRadius: CGFloat = 10) {
        let status = DrawerStatus(type: view.type)
        status.maxWidth = widthType
        status.shadowRadius = shadowRadius
        self.status[view.type] = status
        self.drawerView[view.type] = AnyView(DrawerContainer(content: view, drawerControl: self))
    }
    
    public func setMain<Main: View>(view: Main) {
        let container = MainContainer(content: view, drawerControl: self)
        self.main = AnyView(container)
    }
    
    public func show(type: DrawerType, isShow: Bool) {
        if self.status.first(where: { $0.value.currentStatus.isMoving }) != nil {
            return
        }
        self.status[type]?.currentStatus = isShow ? .show : .hide
    }
    
    public func hideAllSlider() {
        self.status.forEach { $0.value.currentStatus = .hide }
    }
}