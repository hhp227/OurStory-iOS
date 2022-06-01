//
//  Spinner.swift
//  Application
//
//  Created by 홍희표 on 2022/01/30.
//  Copyright © 2022 홍희표. All rights reserved.
//

import SwiftUI
import UIKit

struct Spinner: UIViewRepresentable {
    let isAnimating: Bool
    
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: style)
        spinner.hidesWhenStopped = true
        return spinner
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
