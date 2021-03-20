//
//  OptionalExtensions.swift
//
//    Based on:    https://appventure.me/guides/optionals/extending_optionals.html
//
//  Copyright © 2019-2021 Purgatory Design. Licensed under the MIT License.
//

import Foundation

public extension Optional {

    @inlinable var isNone: Bool {
        return self == nil
    }

    @inlinable var isSome: Bool {
        return self != nil
    }
}

public extension Optional {

    @inlinable func filter(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
        return self.flatMap { predicate($0) ? $0 : nil }
    }

    func expect(_ fatalMessage: String = "Expected a value") -> Wrapped {
        if let unwrapped = self { return unwrapped }
        fatalError(fatalMessage)
    }
}

public extension Optional {

    @inlinable func or(_ else: @autoclosure () -> Wrapped) -> Wrapped {
        return self ?? `else`()
    }

    @inlinable func or(else: () -> Wrapped) -> Wrapped {
        return self ?? `else`()
    }

    func or(throw exception: @autoclosure () -> Error) throws -> Wrapped {
        if let unwrapped = self { return unwrapped }
        throw exception()
    }
}

public extension Optional where Wrapped: Error {

    @inlinable func or(_ else: @escaping (Error) -> Void) {
        if let error = self { `else`(error) }
    }
}

public extension Optional where Wrapped: Collection {

    @inlinable var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }

    @inlinable var isNotEmptyOrNil: Bool {
        return !self.isEmptyOrNil
    }
}
