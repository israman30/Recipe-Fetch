//
//  RecipesViewModel.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/4/25.
//

import SwiftUI

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
