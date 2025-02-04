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

struct ShadowText: ViewModifier {
    var x: CGFloat
    var y: CGFloat
    var cornerRadius: CGFloat
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.4))
            .cornerRadius(10)
            .offset(x: x, y: y)
    }
}

extension View {
    func shadowText(x: CGFloat = 0, y: CGFloat = 0, cornerRadius: CGFloat = 10) -> some View {
        modifier(ShadowText(x: x, y: y, cornerRadius: cornerRadius))
    }
}
