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

/// The `APIClient` protocol defines the blueprint for a generic URL fetch function.
protocol APIClient {
    func fetch<T: Decodable>(url: URL) async throws -> T
}

/// `Error` handler enum
enum APIError: Error {
    case invalidURL
    case errorResponse
    case errorGettingDataFromNetworkLayer(_ message: Error)
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case unknownError(statusCode: Int)
    case failDecodingRecipe(_ localized: String)
    case errorFetchingRecipes(_ localized: String)
}

extension APIError {
    var errorDescription: String? {
        switch self {
        case .failDecodingRecipe(let localized):
            return "Failed decoding recipe: \(localized)"
        case .errorFetchingRecipes(let localized):
            return "Error fetching recipes: \(localized)"
        default:
            return nil
        }
    }
}

class NetworkManager: APIClient {
    
    func fetch<T: Decodable>(url: URL) async throws -> T {
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.errorResponse
        }
        
        try invalid(response)
        
        return try JSONDecoder().decode(Recipes.self, from: data).recipes as! T
    }
    
    func invalid(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200...399:
            return
        case 400...599:
            throw APIError.clientError(statusCode: response.statusCode)
        case 600...799:
            throw APIError.serverError(statusCode: response.statusCode)
        default:
            throw APIError.unknownError(statusCode: response.statusCode)
        }
    }
}
