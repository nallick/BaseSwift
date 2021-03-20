//
//  ResultExtensions.swift
//
//  Copyright © 2019-2021 Purgatory Design. Licensed under the MIT License.
//

import Foundation

extension Result {

    @inlinable public var isSuccess: Bool {
        guard case .success(_) = self else { return false }
        return true
    }

    @inlinable public var isFailure: Bool {
        guard case .failure(_) = self else { return false }
        return true
    }

    @inlinable public var value: Success? {
        guard case let .success(value) = self else { return nil }
        return value
    }

    @inlinable  public var error: Failure? {
        guard case let .failure(error) = self else { return nil }
        return error
    }

    @inlinable public func or(_ else: @escaping (Error) -> Void) {
        if let error = self.error { `else`(error) }
    }

    public func or(_ else: @escaping (Error) -> Success) -> Success {
        switch self {
            case .success(let value): return value
            case .failure(let error): return `else`(error)
        }
    }
}

#if canImport(ObjectiveC)

import Combine

@available(iOS 13.0, macOS 10.15, *)
extension Result {

    @inlinable public var just: Just<Result<Success, Failure>> {
        return Just(self)
    }
}

@available(iOS 13.0, macOS 10.15, *)
extension Publisher {

    public var result: AnyPublisher<Result<Output, Failure>, Never> {
        self.map { Result<Output, Failure>.success($0) }
            .catch { Just(Result<Output, Failure>.failure($0)) }
            .eraseToAnyPublisher()
    }
}

#endif
