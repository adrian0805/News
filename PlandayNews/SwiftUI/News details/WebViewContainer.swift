//
//  WebViewContainer.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 09.03.2021.
//

import Foundation
import SwiftUI

struct WebViewContainer: View {
    var article: Article
    var body: some View {
        VStack {
            SourceView(article: article)
                .frame(height: 60)
                .padding(.horizontal, 10)
            WebView(request: request)
        }.navigationBarHidden(true)
    }
    
    var request: URLRequest? {
        guard let urlString = article.url,
              let url = URL(string: urlString) else {
            return nil
        }
        return URLRequest(url: url)
    }
}
