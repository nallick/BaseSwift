//
//  XCTestCaseExtensions.swift
//
//  See: https://www.swiftbysundell.com/articles/unit-testing-code-that-uses-async-await/
//

import XCTest

@available(swift 5.5)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension XCTestCase {

    public func performAsyncTest(named name: String = #function, timeout: TimeInterval = 10, _ test: @escaping () async -> Void) {
        let expectation = self.expectation(description: name)
        Task {
            await test()
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }

    public func performAsyncTest(named name: String = #function, timeout: TimeInterval = 10, _ test: @escaping () async throws -> Void) throws {
        var thrownError: Error?
        let errorHandler = { thrownError = $0 }
        let expectation = self.expectation(description: name)        
        Task {
            do {
                try await test()
            } catch {
                errorHandler(error)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
        if let error = thrownError { throw error }
    }
}
