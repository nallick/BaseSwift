//
//  CombineExtensionTests.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//
#if canImport(Combine)

import BaseSwift
import Combine
import XCTest

@available(swift 5.5)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
final class CombineExtensionTests: XCTestCase {

    fileprivate enum TestError: Error { case anError, anotherError }

    func testAsyncPublisherResultSuccess() async {
        let expectedValue = 123
        let publisher = CurrentValueSubject<Int, TestError>(expectedValue)

        let actualResult = await publisher.asyncResult()

        XCTAssertEqual(actualResult.value, expectedValue)
    }

    func testAsyncPublisherResultFailure() async {
        let expectedError = TestError.anError
        let publisher = CurrentValueSubject<Int, TestError>(0)
        publisher.send(completion: .failure(expectedError))

        let actualResult = await publisher.asyncResult()

        XCTAssertEqual(actualResult.error, expectedError)
    }

    func testThrowingAsyncPublisherSuccess() async throws {
        let expectedValue = 123
        let publisher = CurrentValueSubject<Int, TestError>(expectedValue)

        let actualValue = try await publisher.async()

        XCTAssertEqual(actualValue, expectedValue)
    }

    func testThrowingAsyncPublisherFailure() async {
        let expectedError = TestError.anError
        let publisher = CurrentValueSubject<Int, TestError>(0)
        publisher.send(completion: .failure(expectedError))

        var actualError: TestError?
        do {
            _ = try await publisher.async()
        } catch {
            actualError = error as? TestError
        }

        XCTAssertEqual(actualError, expectedError)
    }

    func testNonFailingPublisherValue() async {
        let expectedValue = 456
        let publisher = CurrentValueSubject<Int, Never>(expectedValue)

        let actualValue = await publisher.async()

        XCTAssertEqual(actualValue, expectedValue)
    }
}

#endif
