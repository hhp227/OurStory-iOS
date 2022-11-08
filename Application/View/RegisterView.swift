//
//  RegisterView.swift
//  Application
//
//  Created by 홍희표 on 2021/07/29.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel: RegisterViewModel = InjectorUtils.instance.provideRegisterViewModel()
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
