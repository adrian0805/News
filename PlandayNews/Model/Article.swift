//
//  Article.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 09.03.2021.
//

import Foundation

struct Article: Codable, Hashable {
    let source: Source?
    let title: String?
    let author: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?
    let content: String?
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.url == rhs.url
    }
}

struct Source: Codable, Hashable {
    let id: String?
    let name: String?
}
