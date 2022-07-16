//
//  TaskExtensions.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import Foundation

@available(swift 5.5)
@available(iOS 13, macOS 10.15, watchOS 8, tvOS 13, *)
extension Task where Success == Never, Failure == Never {

    public static func sleep(for duration: TimeInterval) async throws {
        let sleepTime = (duration*1_000_000_000).rounded()
        try await Self.sleep(nanoseconds: UInt64(sleepTime))
    }
}

//  Based on: https://www.swiftbysundell.com/articles/delaying-an-async-swift-task/
//
@available(swift 5.5)
@available(iOS 13, macOS 10.15, watchOS 8, tvOS 13, *)
extension Task where Failure == Error {

    public static func delayed(by duration: TimeInterval, priority: TaskPriority? = nil, operation: @escaping @Sendable () async throws -> Success) -> Task {
        Task(priority: priority) {
            try await Task<Never, Never>.sleep(for: duration)
            return try await operation()
        }
    }
}
