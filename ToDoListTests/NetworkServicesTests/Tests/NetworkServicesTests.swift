//
//  NetworkServicesTests.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 12.10.2025.
//

import XCTest
@testable import ToDoList

/// Unit tests for `NetworkServices` using a mock URLSession and URLSessionDataTask.
final class NetworkServicesTests: XCTestCase {
    private var session: MockURLSession!
    private var service: NetworkServices!
    struct TodoTest: Codable, Equatable {
        let id: Int
        let todo: String
    }

    override func setUpWithError() throws {
        session = MockURLSession()
        service = NetworkServices(session: session)
    }
    
    override func tearDownWithError() throws {
        session = nil
        service = nil
    }
    
    /// Tests that `fetchEntityData` correctly decodes valid JSON into the expected model.
    func test_fetchEntityData_decodesValidJSON() throws {
        //Given
        let expectedTodo = TodoTest(
            id: 1,
            todo: "Test todo."
        )
        session.nextData = try JSONEncoder().encode(expectedTodo)
        session.nextResponse = HTTPURLResponse(
            url: try XCTUnwrap(URL(string: "https://example.com")),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let expectation = self.expectation(description: "Fetch completes")
        var receivedTodo: TodoTest?
        
        //When
        service.fetchEntityData(
            url: try XCTUnwrap(URL(string: "https://example.com")),
            type: TodoTest.self
        ) { result in
            if case let .success(todo) = result {
                receivedTodo = todo
            }
            expectation.fulfill()
        }

        //Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(receivedTodo, expectedTodo)
        XCTAssertEqual(session.lastURL?.absoluteString, "https://example.com")
    }
    
    /// Tests that `fetchEntityData` returns a network error when the session fails.
    func test_fetchEntityData_returnsError_onNetworkError() {
        // Given
        let expectedError = NSError(domain: "TestError", code: 1)
        session.nextError = expectedError
        let expectation = self.expectation(description: "Fetch fails")
        var receivedError: Error?
        
        // When
        service.fetchEntityData(
            url: URL(string: "https://example.com")!,
            type: TodoTest.self
        ) { result in
            if case let .failure(error) = result { receivedError = error }
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(receivedError)
        XCTAssertEqual((receivedError as NSError?)?.domain, "TestError")
    }
    
    /// Tests that `fetchEntityData` returns a decoding error for invalid JSON.
    func test_fetchEntityData_returnsError_onInvalidJSON() {
        // Given
        let invalidJSON = "invalid json".data(using: .utf8)
        session.nextData = invalidJSON
        session.nextResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let expectation = self.expectation(description: "Fetch fails on decode")
        var receivedError: Error?
        
        // When
        service.fetchEntityData(
            url: URL(string: "https://example.com")!,
            type: TodoTest.self
        ) { result in
            if case let .failure(error) = result { receivedError = error }
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(receivedError)
        XCTAssertTrue(receivedError is DecodingError)
    }
}
