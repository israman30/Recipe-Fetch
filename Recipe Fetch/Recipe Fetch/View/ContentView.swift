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
    
    init() {
        self._vm = StateObject(wrappedValue: ViewModel(networkManager: NetworkManager()))
    }
    
    var body: some View {
        NavigationView {
            List {
                if vm.recipes.isEmpty {
                    ProgressView()
                } else {
                    ForEach(vm.recipes, id: \.uuid) { recipe in
                        CardView(recipe: recipe)
                    }
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Recipes")
            .task {
                await vm.fechtRecipes(context: context)
            }
        }
    }
}

#Preview {
    ContentView()
}
