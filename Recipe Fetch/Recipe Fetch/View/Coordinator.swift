//
//  Coordinator.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/6/25.
//

import SwiftUI
/// `Page` Enum
///
/// Represents different pages in the app's navigation stack. Conforms to `Hashable` for efficient use in collections like `Set` or as dictionary keys.
///
/// - `home`: Represents the home page.
/// - `recipe(RecipeData)`: Represents a specific recipe page, storing associated `RecipeData`.
///
/// ## Methods:
/// - `==`: Compares two `Page` instances for equality based on their hash values.
/// - `hash(into:)`: Computes a hash value for the `Page` instance, using the recipe's `uuid` for the `.recipe` case.
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

/// `Coordinator` Class
///
/// A class responsible for managing navigation and coordinating the flow between different views in the app.
/// It conforms to `ObservableObject`, allowing it to be used as an environment object for state management and view updates.
///
/// ## Usage:
/// The `Coordinator` is typically used to handle navigation logic, passing data between views, and controlling the app’s flow.
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
/// `CoordinatorView` View
///
/// A view responsible for managing navigation and coordinating the display of different pages using the `Coordinator` class.
/// It utilizes a `NavigationStack` to manage the navigation path and dynamically builds views based on the current `Page`.
///
/// ## Properties:
/// - `@StateObject private var coordinator`: A `Coordinator` object that manages the navigation state and logic.
///
/// ## Body:
/// - The view starts by creating a navigation stack bound to the `coordinator`'s path.
/// - It uses the `coordinator` to build the appropriate view based on the current page.
/// - Navigation destinations are defined for each `Page` type, allowing for dynamic navigation.
///
/// ## Usage:
/// This view integrates the `Coordinator` object and allows for navigation management across different pages of the app.
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
