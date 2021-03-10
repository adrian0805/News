//
//  WebView.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 08.03.2021.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let request: URLRequest?
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let request = request else { return}
        uiView.load(request)
    }
}

