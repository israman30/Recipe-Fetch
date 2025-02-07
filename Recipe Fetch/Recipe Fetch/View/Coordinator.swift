//
//  Coordinator.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/6/25.
//

import SwiftUI

enum Page: Hashable {
    case home
    case recipe(RecipeData)
    
    static func == (lhs: Page, rhs: Page) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .home:
            break
        case .recipe(let recipe):
            hasher.combine(recipe.uuid)
        }
    }
}

class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ page: Page) {
        path.append(page)
    }
    
    @ViewBuilder
    func build(_ page: Page) -> some View {
        switch page {
        case .home:
            ContentView()
        case .recipe(let recipeData):
            RecipeDetailView(recipeData: recipeData)
        }
    }
}

struct CoordinatorView: View {
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(.home)
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page)
                }
        }
        .environmentObject(coordinator)
    }
}
