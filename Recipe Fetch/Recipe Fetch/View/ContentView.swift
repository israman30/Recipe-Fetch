//
//  ContentView.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/3/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm: ViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: RecipeData.entity(), sortDescriptors: []) var results: FetchedResults<RecipeData>
    
    init() {
        self._vm = StateObject(wrappedValue: ViewModel(networkManager: NetworkManager()))
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
                        .navigationTitle("Recipes")
                    }
                    
                } else {
                    List {
                        ForEach(results) { result in
                            CardView(recipeData: result)
                        }
                    }
                    .listStyle(.grouped)
                    .navigationTitle("Recipes")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
