//
//  NetworkManager.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/4/25.
//

import SwiftUI

struct Endpoint {
    static let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
}

enum APIError: Error {
    case invalidURL
    case errorResponse
    case errorGettingDataFromNetworkLayer(_ message: Error)
    case failDecodingRecipe(_ localized: String)
}

protocol APIClient {
    func fetch() async throws -> [Recipe]
}

class NetworkManager: APIClient {
    
    func fetch() async throws -> [Recipe] {
        guard let url = Endpoint.url else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
                (200...300).contains(response.statusCode) else {
            throw APIError.errorResponse
        }
        return try JSONDecoder().decode(Recipes.self, from: data).recipes
    }
}
