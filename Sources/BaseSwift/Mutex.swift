//
//  Mutex.swift
//
//  Copyright © 2018-2020 Purgatory Design. Licensed under the MIT License.
//

import Foundation

public final class Mutex {

    @inlinable public func lock() {
        pthread_mutex_lock(&self.mutex)
    }

    @inlinable public func unlock() {
        pthread_mutex_unlock(&self.mutex)
    }

    @inlinable public func tryLock() -> Bool {
        return pthread_mutex_trylock(&self.mutex) == 0
    }

    @discardableResult
    public func sync<Result>(_ function: () -> Result) -> Result {
        self.lock()
        defer { self.unlock() }
        return function()
    }

    public init(recursive: Bool = false) {
        var attributes = pthread_mutexattr_t()
        pthread_mutexattr_init(&attributes)
        if recursive {
            pthread_mutexattr_settype(&attributes, Int32(PTHREAD_MUTEX_RECURSIVE))
        }

        self.mutex = pthread_mutex_t()
        pthread_mutex_init(&self.mutex, &attributes)
    }

    @inlinable deinit {
        pthread_mutex_destroy(&self.mutex)
    }

    @usableFromInline internal var mutex: pthread_mutex_t
}
