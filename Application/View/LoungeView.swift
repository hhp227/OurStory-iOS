//
//  LoungeView.swift
//  Application
//
//  Created by 홍희표 on 2021/08/13.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct LoungeView: View {
    
    var body: some View {
        ZStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(
                        destination: WriteView()) {
                        Text("+").font(.system(.largeTitle)).frame(width: 66, height: 60).foregroundColor(.white).padding(.bottom, 7)
                    }.background(Color.blue).cornerRadius(38.5).padding().shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                }
            }
        }
    }
}

struct LoungeView_Previews: PreviewProvider {
    static var previews: some View {
        LoungeView()
    }
}
