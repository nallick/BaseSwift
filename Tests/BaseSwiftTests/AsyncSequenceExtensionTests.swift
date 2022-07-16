//
//  AsyncSequenceExtensionTests.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import BaseSwift
import XCTest

@available(swift 5.5)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
final class AsyncSequenceExtensionTests: XCTestCase {

    func testFirstReturnsFirstInSequence() async throws {

        struct ArrayIterator: AsyncSequence, AsyncIteratorProtocol {
            typealias Element = Int
            fileprivate let values: [Int]
            fileprivate var index = 0

            func makeAsyncIterator() -> ArrayIterator {
                self
            }

            mutating func next() async throws -> Int? {
                guard index < values.count else { return nil }
                defer { index += 1}
                return values[index]
            }
        }

        let expectedValue = 1
        let actualValue = try await ArrayIterator(values: [expectedValue, 2, 3]).first()

        XCTAssertEqual(actualValue, expectedValue)
    }
}
