//
//  CombineExtensions.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

#if canImport(Combine)

import Combine
import Foundation

@available(swift 5.5)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Publisher {

    public func asyncResult() async -> Result<Output, Failure> {
        await withCheckedContinuation { continuation in
            var pipeline: AnyCancellable?
            pipeline = self
                .sink { completion in
                    pipeline = nil
                    if case .failure(let error) = completion { continuation.resume(returning: Result.failure(error)) }
                } receiveValue: { result in
                    pipeline?.cancel()
                    pipeline = nil
                    continuation.resume(returning: Result.success(result))
                }
        }
    }

    public func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var pipeline: AnyCancellable?
            pipeline = self
                .sink { completion in
                    pipeline = nil
                    if case .failure(let error) = completion { continuation.resume(throwing: error) }
                } receiveValue: { result in
                    pipeline?.cancel()
                    pipeline = nil
                    continuation.resume(returning: result)
                }
        }
    }
}

@available(swift 5.5)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Publisher where Failure == Never {

    public func async() async -> Output {
        await withCheckedContinuation { continuation in
            var pipeline: AnyCancellable?
            pipeline = self
                .sink { result in
                    pipeline?.cancel()
                    pipeline = nil
                    continuation.resume(returning: result)
                }
        }
    }
}

#endif
