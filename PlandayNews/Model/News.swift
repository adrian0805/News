//
//  News.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 09.03.2021.
//

import Foundation

struct News: Codable {
    let articles: [Article]
    let totalResults: Int
}
