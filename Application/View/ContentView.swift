//
//  ContentView.swift
//  application
//
//  Created by 홍희표 on 2020/05/17.
//  Copyright © 2020 홍희표. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewModel: LoginViewModel = InjectorUtils.instance.provideLoginViewModel()
    
    //@ObservedObject var viewModel: ContentViewModel = ContentViewModel()
    
    var body: some View {
        if UserDefaultsManager.instance.user != nil {
            MainView()
        } else {
            LoginView().environmentObject(viewModel).animation(.easeIn)
        }
        //EmptyView().onAppear(perform: viewModel.test)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UserDefaults {
    @objc var musicVolume: Float {
        get {
            return float(forKey: "music_volume")
        }
        set {
            set(newValue, forKey: "music_volume")
        }
    }
}
