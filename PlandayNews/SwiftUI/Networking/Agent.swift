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

struct Response<T> {
    let value : T
    let reponse: URLResponse
}

