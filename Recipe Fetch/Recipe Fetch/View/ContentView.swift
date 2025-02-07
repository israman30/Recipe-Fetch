//
//  ContentView.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/3/25.
//

import SwiftUI
import CoreData

///```swift
/// `RecipeView` View
///
/// This view manages the state and dependencies related to displaying and interacting with recipes.
/// It utilizes a combination of `@StateObject`, `@Environment`, and `@FetchRequest` to handle the data flow and Core Data integration.
///
/// ## Properties:
/// - `@StateObject var vm`: The `RecipeViewModel` that manages the recipe-related logic and business data.
/// - `@Environment(\.managedObjectContext) var context`: The Core Data context injected by the environment for performing Core Data operations.
/// - `@FetchRequest var results`: A fetch request that retrieves `RecipeData` from Core Data, sorted by the `name` attribute in ascending order.
/// - `@EnvironmentObject var coordinator`: An environment object used for navigation and coordinating between views.
///
/// ## Initialization:
/// The `RecipeView` is initialized by creating a `StateObject` for the `RecipeViewModel` and injecting a `NetworkManager` for API interactions.
///```
struct ContentView: View {
    @StateObject var vm: RecipeViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(
        entity: RecipeData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \RecipeData.name, ascending: true)]
    ) private var results: FetchedResults<RecipeData>
    @EnvironmentObject private var coordinator: Coordinator
    
    init() {
        self._vm = StateObject(wrappedValue: RecipeViewModel(networkManager: NetworkManager()))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if results.isEmpty {
                    if vm.recipes.isEmpty {
                        ProgressView()
                            .task {
                                await vm.fechtRecipes(context: context)
                            }
                    } else {
                        List {
                            ForEach(vm.recipes, id: \.uuid) { recipe in
                                CardView(recipe: recipe)
                            }
                        }
                        .listStyle(.grouped)
                    }
                    
                } else {
                    List {
                        ForEach(results) { result in
                            Button {
                                coordinator.push(.recipe(result))
                            } label: {
                                CardView(recipeData: result)
                            }
                        }
                    }
                    .listStyle(.grouped)
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                Button {
                    reloadData()
                } label: {
                    Image(systemName: "arrow.trianglehead.clockwise")
                }
            }
        }
    }
    
    /// Resetting the data in preparation for reloading.
    private func reloadData() {
        do {
            results.forEach { recipe in
                context.delete(recipe)
            }
            try context.save()
            self.vm.recipes.removeAll()
        } catch {
            print("Error deleting data: \(error)")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Coordinator())
}
