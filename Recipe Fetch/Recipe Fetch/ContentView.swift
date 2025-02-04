//
//  ContentView.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/3/25.
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

@MainActor
class ViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    private let networkManager: APIClient
    
    init(networkManager: APIClient) {
        self.networkManager = networkManager
    }
    
    func fechtRecipes() async {
        do {
            self.recipes = try await networkManager.fetch()
            print(self.recipes)
        } catch {
            print("DEBUG: \(APIError.errorGettingDataFromNetworkLayer(error))")
        }
    }
}

struct ContentView: View {
    @StateObject var vm: ViewModel
    
    init() {
        self._vm = StateObject(wrappedValue: ViewModel(networkManager: NetworkManager()))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.recipes, id: \.uuid) { recipe in
                    VStack(alignment: .leading) {
                        Text(recipe.name)
                            .font(.headline)
                        Text(recipe.cuisine)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Recipes")
            .task {
                await vm.fechtRecipes()
            }
        }
    }
}

#Preview {
    ContentView()
}
