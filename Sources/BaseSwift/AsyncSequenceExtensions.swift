//
//  AsyncSequenceExtensions.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import Foundation

@available(swift 5.5)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension AsyncSequence {

    @inlinable public func first() async rethrows -> Self.Element? {
        try await self.first(where: { _ in true })
    }
}
