# Recipe-Fetch
#### Candidate: Israel Manzo
### Summary: Include screen shots or a video of your app highlighting its features
<p align="center">
<img src="img/main.png" width="250"> <img src="img/detail.png" width="250">
</p>

### Summary:

### **Recipe App - Key Features & Requirements**  

🔹 **Two-Screen UI**: Display a list of recipes with name, photo, and cuisine type using SwiftUI and shows a detailed view where users can access additional information about each recipe.

🔹 **Software Design Pattern**: Implemented MVVM to enhance separation of concerns and maintainability.
```swift
// A protocol that defines the blueprint for a recipe view model.
// It ensures that conforming types manage a list of recipes (`[Recipe]`) and are observed on the main thread.
@MainActor
protocol RecipeViewModelProtocol: ObservableObject {
    var recipes: [Recipe] { get set }
}
```
> [!NOTE]
> The new [Observable](https://developer.apple.com/documentation/swiftui/migrating-from-the-observable-object-protocol-to-the-observable-macro) API, available in `iOS 17+`, can also be used for `Observation`. However, since the minimum supported version (Fetch) for the app is `iOS 16+`, `ObservableObject` was chosen instead.

🔹 **Asynchronous Operations**: Leverage Swift Concurrency (`async/await`) for API calls and image loading.  
```swift
// Defines a blueprint for a network client that fetches and decodes data from a given URL.
protocol APIClient {
    func fetch<T: Decodable>(url: URL) async throws -> T
}
```

🔹 **Manual Image Caching**: Implement disk caching to minimize redundant network requests—no third-party libraries.  
Using a `PersistenceContainer`, the data fetched from the API is saved to local storage using Core Data.
```swift
private func save(context: NSManagedObjectContext) {
    recipes.forEach { recipe in
        // Creating a context from Core Data model entities
    }
}

func fechtRecipes(context: NSManagedObjectContext) async {
    // After fetching data from the internet,
    self.recipes = try await networkManager.fetch(url: url)
    // save the context to local storage.
    self.save(context: context)
}
```

> [!NOTE]
> The new [SwiftData](https://developer.apple.com/documentation/swiftdata/) API, available in `iOS 17+`, can also be used for local storage. However, since the minimum supported version (Fetch) for the app is `iOS 16+`, Core Data was chosen instead.


🔹 **Efficient Networking**: Load images only when needed to optimize bandwidth usage. `AsyncImage` is a powerful feature in SwiftUI that simplifies the process of asynchronously loading and displaying remote images in the App. [Apple documentation](https://developer.apple.com/documentation/swiftui/asyncimage)
```swift
AsyncImage(url: ...)
```

🔹 **User-Initiated Refresh**: Enable users to manually refresh the recipe list for updated content.  

🔹 **Apple-Only Frameworks**: No external dependencies for networking, caching, or testing.  

🔹 **Unit Testing**: Focus on testing core logic like data fetching and caching to ensure reliability.  

🔹 **SwiftUI-Driven**: Modern UI implementation showcasing Apple’s latest UI framework with support of both light and dark themes, as well as portrait and landscape orientations.  

🚀 **Goal**: Deliver a high-performance, well-structured SwiftUI app with optimized networking, caching, and concurrency while maintaining clean architecture and testability. 

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
 

1️⃣ **Efficient Network Requests**:  
   - Implemented **Async image loading** to fetch images only when needed in the UI, preventing unnecessary API calls.  
   - Used **manual disk caching** to store images, reducing redundant network requests and improving app responsiveness.  
   - Ensured **concurrent API handling** with Swift Concurrency (`async/await`) to maintain smooth performance.  

2️⃣ **Optimized Memory Usage**:  
   - Leveraged **on-demand image loading** and deallocated unused resources to prevent memory bloat.  
   - Implemented **data persistence** for caching recipes locally, reducing network dependency and improving offline performance.  
   - Used **SwiftUI's efficient rendering** mechanisms to minimize UI overhead and ensure a smooth scrolling experience.  

🔹 **Why These Priorities?**  
   These areas were critical to delivering a high-performance app that minimizes bandwidth usage, provides a seamless user experience, and adheres to best practices for Swift Concurrency and memory management. 🚀

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?

- Dedicated around 3 hours per day over the course of 5 days, strategically allocating time for feature development and systematic refactoring.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

Yes, I made several trade-offs to optimize performance, memory usage, and speed.  

- **Optimized Image Loading with AsyncImage**: Instead of using third-party libraries or manually implementing a caching mechanism, I leveraged SwiftUI’s `AsyncImage` to efficiently load and display images. While this simplified implementation and utilized system-level optimizations, it limited fine-grained control over caching behavior. However, it ensured efficient memory usage and reduced redundant network requests while maintaining smooth performance. 

- **Minimal UI Components**: I kept the UI simple with a single screen to focus on efficient data handling rather than complex layouts. While this limited visual enhancements, it ensured a smooth and responsive experience.  

- **Asynchronous Data Fetching**: I leveraged Swift Concurrency (`async/await`) to ensure non-blocking network requests and image loading. This improved responsiveness but required careful error handling and structured concurrency management.  

- **Balancing Memory and Performance**: To reduce memory usage, I opted for lazy loading images only when they appear on-screen. This improved efficiency but required additional logic to handle image loading states properly.  

- I used **Coordinators** as the navigation stack instead of `NavigationLink` to achieve better scalability, separation of concerns, and flexibility in managing complex navigation flows. Unlike `NavigationLink`, which tightly couples navigation logic to the view hierarchy, Coordinators centralize navigation control, making the app more modular, testable, and easier to maintain as it scales.

These trade-offs helped ensure the app remained performant, responsive, and optimized for real-world usage.

### Weakest Part of the Project: What do you think is the weakest part of your project?

Implemented support for opening links, as WebKit and SafariViewController still present limitations and inconsistencies within SwiftUI.

Enhance the UI slightly for a better user experience.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.

There is a warning `Error creating the CFMessagePort needed to communicate with PPT.` Occurs when Core Data performs a VACUUM operation to free up space in the SQLite database. This message is expected and does not indicate an issue. More details can be found here. [source](https://stackoverflow.com/questions/69002421/coredata-annotation-postsavemaintenance-incremental-vacuum-with-freelist-coun)



### Supported Platforms:  
- **Xcode** 16.2  
- **iOS** 18.2  
- **iPhone** 16 Pro  
- **Xcode Simulator** 16.0  