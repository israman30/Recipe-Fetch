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
    case errorGettingDataFromNetworkLayer(_ message: String)
    case failDecodingArticles(_ localized: String)
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
        
        guard let response = response as? HTTPURLResponse, (200...300).contains(response.statusCode) else {
            throw APIError.errorResponse
        }
        return try JSONDecoder().decode(Welcome.self, from: data).recipes
    }
}

@MainActor
class ViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fechtRecipes() async {
        
    }
}

struct ContentView: View {
    @StateObject var vm: ViewModel
    
    init() {
        self._vm = StateObject(wrappedValue: ViewModel(networkManager: NetworkManager()))
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            await vm.fechtRecipes()
        }
    }
}

#Preview {
    ContentView()
}
