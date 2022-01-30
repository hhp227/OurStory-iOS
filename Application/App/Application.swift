//
//  Application.swift
//  application
//
//  Created by 홍희표 on 2020/05/17.
//  Copyright © 2020 홍희표. All rights reserved.
//

import SwiftUI

@main
struct Application: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init(UserRepository(ApiServiceImpl())))
        }
    }
}
