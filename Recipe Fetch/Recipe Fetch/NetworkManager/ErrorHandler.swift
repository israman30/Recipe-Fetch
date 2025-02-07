//
//  ErrorHandler.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/7/25.
//

import Foundation

/// /// `APIError` Enum
///
/// Represents various errors that can occur during API requests.
///
/// - `invalidURL`: The provided URL is invalid.
/// - `errorResponse`: The response from the server is not valid.
/// - `errorGettingDataFromNetworkLayer`: An error occurred while fetching data from the network.
/// - `clientError`: A client-side error with a given status code.
/// - `serverError`: A server-side error with a given status code.
/// - `unknownError`: An unknown error with a given status code.
/// - `failDecodingRecipe`: Failed to decode a recipe with a localized error message.
/// - `errorFetchingRecipes`: An error occurred while fetching recipes with a localized error message.
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
