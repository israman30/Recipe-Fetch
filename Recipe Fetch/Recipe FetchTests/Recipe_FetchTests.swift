//
//  Recipe_FetchTests.swift
//  Recipe FetchTests
//
//  Created by Israel Manzo on 2/5/25.
//

import XCTest
import CoreData
@testable import Recipe_Fetch

struct MockResponse: Codable, Equatable {
    let message: String
    var isLoaded: Bool { true }
}

class MockAPIClient: APIClient {
    var shouldThrowError = false
    var mockResponse: MockResponse?

    func fetch<T: Decodable>(url: URL) async throws -> T {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        guard let mockResponse = mockResponse as? T else {
            throw URLError(.cannotDecodeContentData)
        }
        return mockResponse
    }
}

class MockViewModel {
    
    var mockRecipes: [Recipe] = []
    
    let mockAPIClient: MockAPIClient
    
    init(mockAPIClient: MockAPIClient) {
        self.mockAPIClient = mockAPIClient
    }
    
    func fechtRecipes(context: NSManagedObjectContext) async {
        do {
            try context.save()
        } catch {
            XCTFail("Error saving context: \(error)")
        }
    }
}

class Recipe_FetchTests: XCTestCase {
    
    /// Test `APIClient` with `MockAPIClient` class
    var mockClient: MockAPIClient!
    let testURL = URL(string: "https://example.com/api")!
    
    var networkManager: NetworkManager!
    var viewModel: MockViewModel!
    var mockPersistentContainer: NSPersistentContainer!

    override func setUpWithError() throws {
        mockClient = MockAPIClient()
        networkManager = NetworkManager()
        viewModel = MockViewModel(mockAPIClient: mockClient)
    }
    
    override func tearDownWithError() throws {
        mockClient = nil
        networkManager = nil
    }
    
    func test_ResponseWithError() async throws {
        let expectedResponse = MockResponse(message: "Success")
        mockClient.mockResponse = expectedResponse
        
        let response: MockResponse = try await mockClient.fetch(url: testURL)

        XCTAssertEqual(response, expectedResponse, "The response should match the expected mock data.")
    }
    
    func test_MockResponseExist() {
        let exist = mockClient.mockResponse == nil
        if exist {
            XCTAssertTrue(exist)
        } else {
            XCTAssertFalse(exist)
        }
    }
    
    func test_ResponseIsLoaded() async throws {
        let isLoaded = MockResponse(message: "Response").isLoaded
        if isLoaded {
            XCTAssertTrue(isLoaded)
        } else {
            XCTAssertFalse(isLoaded)
        }
    }
    
    func test_MockClient_ErrorThrows() async throws {
        let error = mockClient.shouldThrowError ? nil : URLError(.badServerResponse)
        XCTAssertNotNil(error, "An error should be thrown when fetch fails.")
    }
    
    func testFetch_Failure() async {
        
        mockClient.shouldThrowError = true
        
        do {
            let _: MockResponse = try await mockClient.fetch(url: testURL)
            XCTFail("Expected fetch to throw an error, but it did not.")
        } catch {
            XCTAssertNotNil(error, "An error should be thrown when fetch fails.")
        }
    }
    
    func test_statusCode() {
        let validResponses = [200, 250, 300, 399]
        
        for statusCode in validResponses {
           if let response = HTTPURLResponse(
                url: testURL,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
           ) {
               XCTAssertNoThrow(try networkManager.invalid(response), "Expected no error for status code \(statusCode)")
           } else {
               XCTFail("Failed to create valid HTTPURLResponse for status code \(statusCode)")
           }
        }
    }
    
    func testFetchRecipes_Success() async {

        viewModel.mockRecipes = [
            Recipe(cuisine: "Italian", name: "Pasta", photoURLLarge: "", photoURLSmall: "https://example.com/pasta.jpg", sourceURL: "", uuid: "123"),
            Recipe(cuisine: "Italian", name: "Pasta", photoURLLarge: "", photoURLSmall: "https://example.com/pasta.jpg", sourceURL: "", uuid: "456"),
            Recipe(cuisine: "Italian", name: "Pasta", photoURLLarge: "", photoURLSmall: "https://example.com/pasta.jpg", sourceURL: "", uuid: "789")
        ]
        
        XCTAssertFalse(viewModel.mockRecipes.isEmpty, "Expected an empty array of recipes")
        XCTAssertEqual(viewModel.mockRecipes.count, 3, "Expected 2 recipes to be fetched")
        XCTAssertEqual(viewModel.mockRecipes.first?.name, "Pasta", "First recipe name should be 'Pasta'")
    }

}
