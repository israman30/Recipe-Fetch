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
/// /// `APIClient` Protocol
///
/// Defines a blueprint for a network client that fetches and decodes data from a given URL.
///
/// ## Usage:
/// - Conforms to `async/await` concurrency.
/// - Supports decoding of `Decodable` types.
///
/// ## Requirements:
/// - Implement `fetch(url:)` to perform network requests and decode the response.
///
/// ## Example:
/// ```swift
/// struct NetworkManager: APIClient {
///     func fetch<T: Decodable>(url: URL) async throws -> T {
///         let (data, _) = try await URLSession.shared.data(from: url)
///         return try JSONDecoder().decode(T.self, from: data)
///     }
/// }
/// ```

/// Fetches and decodes data from the specified URL.
///
/// - Parameter url: The `URL` to request data from.
/// - Returns: A decoded object of type `T`.
/// - Throws: An error if the request or decoding fails.
protocol APIClient {
    func fetch<T: Decodable>(url: URL) async throws -> T
}

/// `NetworkManager` Class
///
/// Conforms to the `APIClient` protocol to handle network requests and data decoding.
/// It uses `URLSession` to fetch data from a given URL and decodes the response into a `Decodable` object.
///
/// ## Example:
/// ```swift
/// let manager = NetworkManager()
/// let data: MyModel = try await manager.fetch(url: myURL)
/// ```
class NetworkManager: APIClient {
    
    func fetch<T: Decodable>(url: URL) async throws -> T {
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.errorResponse
        }
        
        try invalid(response)
        
        do {
            return try JSONDecoder().decode(Recipes.self, from: data).recipes as! T
        } catch {
            throw APIError.failDecodingRecipe(error.localizedDescription)
        }
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
