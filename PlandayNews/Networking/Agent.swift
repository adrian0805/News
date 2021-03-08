//
//  Agent.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 03.03.2021.
//

import Foundation
import Combine

enum NewsError: String, Error {
    case invalidURL = "The URL is invalid. Pease try again."
}

struct NetworkAgent {
    let decoder: JSONDecoder
    
    init() {
        decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    struct Response<T> {
        let value : T
        let reponse: URLResponse
    }
    
    func run<T: Decodable> (_ request: URLRequest, _ decoder: JSONDecoder =  JSONDecoder()) -> AnyPublisher< Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result  -> Response<T> in
                let value = try self.decoder.decode(T.self, from: result.data)
                return Response(value: value, reponse: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum NewsAPI {
    static let agent = NetworkAgent()
//    static let baseURL = URL(string: "https://newsapi.org")!
    static let baseURLComponents = URLComponents(string: "https://newsapi.org")
    static let APIKey = "8f48eb37348d4ac88f9f4c12d27607c8"
}

extension NewsAPI {
    static func topHeadlines(country: String = "us", page: Int) -> AnyPublisher<News, Error> {
//        var request = URLRequest(url: baseURL.appendingPathComponent("/v2/top-headlines")
//        var urlComps = URLComponents(string: baseURL + "/v2/top-headlines")!
        var components = baseURLComponents
        components?.path = "/v2/top-headlines"
        components?.queryItems = [ URLQueryItem(name: "country", value: country), URLQueryItem(name: "page", value: String(page)), URLQueryItem(name: "apiKey", value: APIKey)]
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

struct News: Codable {
    let articles: [Article]
    let totalResults: Int
}

struct Article: Codable {
    let source: Source?
    let title: String?
    let author: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?
    let content: String?
}

struct Source: Codable {
    let id: String?
    let name: String?
}
