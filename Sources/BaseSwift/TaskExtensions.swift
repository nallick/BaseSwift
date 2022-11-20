//
//  TaskExtensions.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import Foundation

@available(swift 5.5)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Task {

    @inlinable public var isNotCancelled: Bool {
        !self.isCancelled
    }
}

@available(swift 5.5)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Task where Success == Never, Failure == Never {

    @inlinable public static var isNotCancelled: Bool {
        !Self.isCancelled
    }

    public static func sleep(for duration: TimeInterval) async throws {
        let sleepTime = (duration*1_000_000_000).rounded()
        try await Self.sleep(nanoseconds: UInt64(sleepTime))
    }
}

//  Based on: https://www.swiftbysundell.com/articles/delaying-an-async-swift-task/
//
@available(swift 5.5)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Task where Failure == Error {

    public static func delayed(by duration: TimeInterval, priority: TaskPriority? = nil, operation: @escaping @Sendable () async throws -> Success) -> Task {
        Task(priority: priority) {
            try await Task<Never, Never>.sleep(for: duration)
            return try await operation()
        }
    }
}

@available(swift 5.5)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension UnsafeCurrentTask {

    @inlinable public var isNotCancelled: Bool {
        !self.isCancelled
    }
}

@available(swift 5.5)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension TaskGroup {

    @inlinable public var isNotEmpty: Bool {
        !self.isEmpty
    }

    @inlinable public var isNotCancelled: Bool {
        !self.isCancelled
    }
}

@available(swift 5.5)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension ThrowingTaskGroup {

    @inlinable public var isNotEmpty: Bool {
        !self.isEmpty
    }

    @inlinable public var isNotCancelled: Bool {
        !self.isCancelled
    }
}
