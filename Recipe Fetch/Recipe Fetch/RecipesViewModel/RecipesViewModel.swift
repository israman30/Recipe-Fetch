//
//  RecipesViewModel.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/4/25.
//

import SwiftUI
import CoreData

/// `RecipeViewModelProtocol`: Responsible for updating recipes on the main thread and ensuring they are observable.
@MainActor
protocol RecipeViewModelProtocol: ObservableObject {
    var recipes: [Recipe] { get set }
}

/// `FetchRecipeContextViewModelProtocol`: Responsible for fetching recipes from the endpoint via the network layer and saving the context to local storage.
protocol FetchRecipeContextViewModelProtocol {
    func fechtRecipes(context: NSManagedObjectContext) async
}

class RecipeViewModel: RecipeViewModelProtocol, FetchRecipeContextViewModelProtocol {
    @Published var recipes: [Recipe] = []
    
    private let networkManager: APIClient
    
    init(networkManager: APIClient) {
        self.networkManager = networkManager
    }
    
    /// The custom `save` function is responsible for extracting each `recipe` and persisting it within the `context` entity of the `local storage` system.
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
