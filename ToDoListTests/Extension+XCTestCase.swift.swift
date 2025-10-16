//
//  Extension+.swift.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 17.10.2025.
//

import XCTest

extension XCTestCase {
    /// Reports a failed Core Data operation with a detailed error message.
    func fail(error: Error, expectation: XCTestExpectation) {
        XCTFail("Add Todo failed: \(error.localizedDescription)")
        expectation.fulfill()
    }
}
