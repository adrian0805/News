//
//  Mock.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 09.03.2021.
//

import Foundation

enum Mock {
    static func getMockData(for jsonName: String) -> Data? {
        if let path = Bundle.main.path(forResource: jsonName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                return nil
            }
        }
        return nil
    }
    
    static func getMockObject<T: Codable> (jsonName: String, of type: T.Type) -> T? {
        guard let mockData = Mock.getMockData(for: jsonName) else { return nil}
        do {
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let object = try decoder.decode(T.self, from: mockData)
            return object
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
