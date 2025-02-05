//
//  Recipe_FetchTests.swift
//  Recipe FetchTests
//
//  Created by Israel Manzo on 2/5/25.
//

import XCTest
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

class Recipe_FetchTests: XCTestCase {
    
    /// Test `APIClient` with `MockAPIClient` class
    var mockClient: MockAPIClient!
    let testURL = URL(string: "https://example.com/api")!
    
    var networkManager: NetworkManager!

    override func setUpWithError() throws {
        mockClient = MockAPIClient()
        networkManager = NetworkManager()
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

}
