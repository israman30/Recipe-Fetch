//
//  RecipesViewModel.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/4/25.
//

import SwiftUI
import CoreData

@MainActor
class ViewModel: ObservableObject {
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
            self.recipes = try await networkManager.fetch()
//            print(self.recipes)
            self.save(context: context)
        } catch {
            print("DEBUG: \(APIError.errorGettingDataFromNetworkLayer(error))")
        }
    }
}
