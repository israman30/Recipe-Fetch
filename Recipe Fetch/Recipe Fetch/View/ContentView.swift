//
//  ContentView.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/3/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var vm: RecipeViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(
        entity: RecipeData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \RecipeData.name, ascending: true)]
    ) private var results: FetchedResults<RecipeData>
    
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
                            CardView(recipeData: result)
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
    
    // cleearing data for reloading
    private func reloadData() {
        do {
            results.forEach { recipe in
                context.delete(recipe)
            }
            try context.save()
        } catch {
            print("Error deleting data: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
