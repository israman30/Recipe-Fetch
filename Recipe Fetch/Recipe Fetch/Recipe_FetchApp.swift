//
//  Recipe_FetchApp.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/3/25.
//

import SwiftUI

@main
struct Recipe_FetchApp: App {
    
    let persistenceContainer: PersistenceContainer = .shared
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView()
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
        }
    }
}
