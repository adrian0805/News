//
//  NewsAPI.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 09.03.2021.
//

import Foundation
import Combine

enum NewsAPI {
    static let agent = NetworkAgent()
//    static let baseURL = URL(string: "https://newsapi.org")!
    static let baseURLComponents = URLComponents(string: "https://newsapi.org")
    static let APIKey = "77bdfb46ad214c91b0bc16f459794095"
}

extension NewsAPI {
    static func topHeadlines(country: String = "us", page: Int, category: String? = nil) -> AnyPublisher<News, Error> {
        var components = baseURLComponents
        components?.path = "/v2/top-headlines"
        var queryItems = [ URLQueryItem(name: "country", value: country), URLQueryItem(name: "page", value: String(page)), URLQueryItem(name: "apiKey", value: APIKey)]
        if let category = category {
            queryItems.append(URLQueryItem(name: "category", value: category))
        }
        components?.queryItems = queryItems
        let request = URLRequest(url:(components?.url)!)
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    static func searchNews(searchString: String, page: Int) -> AnyPublisher<News, Error> {
        var components = baseURLComponents
        components?.path = "/v2/everything"
        components?.queryItems = [ URLQueryItem(name: "q", value: searchString), URLQueryItem(name: "page", value: String(page)), URLQueryItem(name: "pageSize", value: 20.description), URLQueryItem(name: "apiKey", value: APIKey)]
        let request = URLRequest(url:(components?.url)!)
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
