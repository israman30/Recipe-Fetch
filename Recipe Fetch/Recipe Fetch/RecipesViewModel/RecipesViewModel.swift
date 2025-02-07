//
//  RecipesViewModel.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/4/25.
//

import SwiftUI
import CoreData

/// /// `RecipeViewModelProtocol` Protocol
///
/// A protocol that defines the blueprint for a recipe view model.
/// It ensures that conforming types manage a list of recipes (`[Recipe]`) and are observed on the main thread.
///
/// - `recipes`: An array of `Recipe` objects to be displayed or managed in the view.
///
/// ## Usage:
/// Conform to this protocol to create view models for managing recipes with SwiftUI.
@MainActor
protocol RecipeViewModelProtocol: ObservableObject {
    var recipes: [Recipe] { get set }
}

/// `FetchRecipeContextViewModelProtocol` Protocol
///
/// A protocol for view models responsible for fetching recipes within a specific Core Data context.
/// It ensures that conforming types can fetch recipes asynchronously using a provided `NSManagedObjectContext`.
///
/// - `fetchRecipes(context:)`: Asynchronously fetches recipes from the provided `NSManagedObjectContext`.
///
/// ## Usage:
/// Conform to this protocol to implement asynchronous fetching of recipes from Core Data.
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
    /// - Parameter context: Recipes from NetworkManager
    private func save(context: NSManagedObjectContext) {
        recipes.forEach { recipe in
            let entity = RecipeData(context: context)
            entity.name = recipe.name
            entity.cuisinie = recipe.cuisine
            entity.photoURLSmall = recipe.photoURLSmall
            entity.uuid = recipe.uuid
            entity.sourceURL = recipe.sourceURL
            entity.youtubeURL = recipe.youtubeURL
        }
        
        do {
            try context.save()
            print("success")
        } catch {
            print("Error: Something went wrong while saving data to CoreData: \(error)")
        }
    }
    
    /// When data is fetched by the NetworkManager, it is saved to the local database.
    /// - Parameter context: Recipes from vm.reasults
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
