//
//  SettingsServiceTests.swift
//  ToDoListTests
//
//  Created by Dmitriy Eliseev on 12.10.2025.
//

import XCTest
@testable import ToDoList


final class SettingsServiceTests: XCTestCase {
    var storage: MockUserDefaults!
    var service: ISettingsService!
    
    override func setUpWithError() throws {
        //Given
        storage = MockUserDefaults()
        service = SettingsService(storage: storage)
    }
    
    override func tearDownWithError() throws {
        storage = nil
        service = nil
    }
    
    // MARK: - Tests
    
    /// Returns false on first app launch and sets the flag in storage.
    func test_isFirstLaunch_returnsFalseOnFirstRun() {
        // when
        let result = service.isFirstLaunch()
        // then
        XCTAssertFalse(result)
    }
    
    /// Returns true if the app has launched before.
    func test_isFirstLaunch_returnsTrueOnSubsequentRuns() {
        // given
        storage.set(true, forKey: SettingsService.StorageKey.hasLaunchedKey)
        // when
        let result = service.isFirstLaunch()
        // then
        XCTAssertTrue(result)
    }
}
