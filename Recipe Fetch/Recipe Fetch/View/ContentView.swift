//
//  ContentView.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/3/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm: ViewModel
    
    init() {
        self._vm = StateObject(wrappedValue: ViewModel(networkManager: NetworkManager()))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.recipes, id: \.uuid) { recipe in
                    CardView(recipe: recipe)
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Recipes")
            .task {
                await vm.fechtRecipes()
            }
        }
    }
}

#Preview {
    ContentView()
}
