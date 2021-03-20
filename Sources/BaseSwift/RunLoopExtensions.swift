//
//  RunLoopExtensions.swift
//
//  Copyright © 2017-2021 Purgatory Design. Licensed under the MIT License.
//

import Foundation

@nonobjc public extension RunLoop {

    /// Make a single pass through the run loop.
    ///
    /// - Parameter mode: The run loop mode.
    ///
    @inlinable func singlePass(forMode mode: RunLoop.Mode = .default) {
        _ = self.limitDate(forMode: mode)
    }
}
