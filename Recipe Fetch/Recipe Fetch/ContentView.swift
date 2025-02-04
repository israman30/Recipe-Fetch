//
//  ContentView.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/3/25.
//

import SwiftUI

class NetworkManager {
    
    private let urlCache: URLCache
    
    init(urlCache: URLCache = .shared) {
        self.urlCache = urlCache
    }
    
    func fetch<T: Decodable>(from url: URL) async throws -> T {
        if let cacheResponse = urlCache.cachedResponse(for: URLRequest(url: url)) {
            let decodeData = try JSONDecoder().decode(T.self, from: cacheResponse.data)
            return decodeData
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpsResponse = response as? HTTPURLResponse, httpsResponse.statusCode == 200 {
            let cacheResponse = CachedURLResponse(response: response, data: data)
            urlCache.storeCachedResponse(cacheResponse, for: URLRequest(url: url))
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
