//
//  PersistenceContainer.swift
//  Recipe Fetch
//
//  Created by Israel Manzo on 2/4/25.
//

import CoreData

struct Constants {
    static let containerName = "Recipe_Fetch"
    static let containerPath = "/dev/null"
}

enum PersistenceError: Error {
    case saveError(NSError, userInfo: [String:Any])
    case loadPersistentStoreError(NSError, userInfo: [String:Any])
    case invalidPersistentStoreURL
    
    var localizedDescription: String {
        switch self {
        case .saveError(let error, let userInfo):
            return "Failed to save context: \(error.localizedDescription) and info: \(userInfo)"
        case .loadPersistentStoreError(let error, let userInfo):
            return "Failed to load persistent store: \(error.localizedDescription) and info: \(userInfo))"
        case .invalidPersistentStoreURL:
            return "Invalid persistent store URL."
        }
    }
}

struct PersistenceContainer {
    static let shared = PersistenceContainer()
    
    static var preview: PersistenceContainer = {
        let result = PersistenceContainer(inMemory: true)
        let viewContext = result.container.viewContext
        
        do {
            try viewContext.save()
        } catch let error as NSError {
            print(PersistenceError.saveError(error, userInfo: error.userInfo))
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: Constants.containerName)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: Constants.containerPath)
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                print(PersistenceError.loadPersistentStoreError(error, userInfo: error.userInfo).localizedDescription)
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
