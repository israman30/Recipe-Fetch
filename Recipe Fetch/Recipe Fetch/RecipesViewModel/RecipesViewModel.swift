//
//  RecipesViewModel.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/4/25.
//

import SwiftUI
import CoreData

@MainActor
class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    private let networkManager: APIClient
    
    init(networkManager: APIClient) {
        self.networkManager = networkManager
    }
    
    private func save(context: NSManagedObjectContext) {
        recipes.forEach { recipe in
            let entity = RecipeData(context: context)
            entity.name = recipe.name
            entity.cuisinie = recipe.cuisine
            entity.photoURLSmall = recipe.photoURLSmall
            entity.uuid = recipe.uuid
            entity.sourceURL = recipe.sourceURL
        }
        
        do {
            try context.save()
            print("success")
        } catch {
            print("Error: Something went wrong while saving data to CoreData: \(error)")
        }
    }
    
    func fechtRecipes(context: NSManagedObjectContext) async {
        do {
            guard let url = Endpoint.url else { return }
            self.recipes = try await networkManager.fetch(url: url)
            self.save(context: context)
        } catch {
            print("DEBUG: \(APIError.errorGettingDataFromNetworkLayer(error))")
        }
    }
}
