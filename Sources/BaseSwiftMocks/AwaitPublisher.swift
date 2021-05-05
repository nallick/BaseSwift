//
//  AwaitPublisher.swift
//
//  See: https://www.swiftbysundell.com/articles/unit-testing-combine-based-swift-code/
//

#if canImport(Combine)

import Combine
import XCTest

extension XCTestCase {

    @available(iOS 13.0, macOS 10.15, *)
    public func awaitPublisher<T: Publisher>(_ publisher: T, timeout: TimeInterval = 2.0, isFulfilledByFirstValue: Bool = false, file: StaticString = #file, line: UInt = #line, isFulfilledBy: ((T.Output) -> Bool)? = nil) throws -> T.Output {
        let result = try awaitResult(from: publisher, timeout: timeout, isFulfilledByFirstValue: isFulfilledByFirstValue, file: file, line: line, isFulfilledBy: isFulfilledBy)
        return try result.get()
    }

    @available(iOS 13.0, macOS 10.15, *)
    public func awaitResult<T: Publisher>(from publisher: T, timeout: TimeInterval = 2.0, isFulfilledByFirstValue: Bool = false, file: StaticString = #file, line: UInt = #line, isFulfilledBy: ((T.Output) -> Bool)? = nil) throws -> Result<T.Output, T.Failure> {
        var result: Result<T.Output, T.Failure>?
        let expectation = self.expectation(description: "Awaiting publisher")

        let cancellable = publisher.sink { completion in
            if case .failure(let error) = completion { result = .failure(error) }
            expectation.fulfill()
        } receiveValue: {
            result = .success($0)
            if isFulfilledByFirstValue || isFulfilledBy?($0) == true {
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        return try XCTUnwrap(result, "Awaited publisher did not produce any output", file: file, line: line)
    }
}

#endif
