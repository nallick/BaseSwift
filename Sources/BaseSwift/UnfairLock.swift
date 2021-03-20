//
//  UnfairLock.swift
//
//  Copyright © 2020 Purgatory Design. Licensed under the MIT License.
//

#if os(Linux)
public typealias UnfairLock = Mutex
#else

import Foundation

public final class UnfairLock {

    @inlinable public func lock() {
        os_unfair_lock_lock(self.unfairLock)
    }

    @inlinable public func unlock() {
        os_unfair_lock_unlock(self.unfairLock)
    }

    @inlinable public func tryLock() -> Bool {
        return os_unfair_lock_trylock(self.unfairLock)
    }

    @inlinable public func assertOwner() {
        os_unfair_lock_assert_owner(self.unfairLock)
    }

    @inlinable public func assertNotOwner() {
        os_unfair_lock_assert_not_owner(self.unfairLock)
    }

    @discardableResult
    public func sync<Result>(_ function: () -> Result) -> Result {
        self.lock()
        defer { self.unlock() }
        return function()
    }

    public init() {
        self.unfairLock = os_unfair_lock_t.allocate(capacity: 1)
        self.unfairLock.initialize(repeating: os_unfair_lock_s(), count: 1)
    }

    deinit {
        self.unfairLock.deinitialize(count: 1)
        self.unfairLock.deallocate()
    }

    @usableFromInline internal var unfairLock: os_unfair_lock_t
}

#endif
