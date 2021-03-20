//
//  UtilityOperators.swift
//
//  Copyright © 2019-2021 Purgatory Design. Licensed under the MIT License.
//

infix operator ?= : AssignmentPrecedence
infix operator ??= : AssignmentPrecedence

@inlinable public func ?= <T>(lhs: inout T, rhs: T?) { lhs = rhs ?? lhs }     // a ?= b -> a becomes b UNLESS b is nil

@inlinable public func ?= <T>(lhs: inout T?, rhs: T?) { lhs = rhs ?? lhs }

@inlinable public func ??= <T>(lhs: inout T?, rhs: T) { lhs = lhs ?? rhs }    // a ??= b -> a becomes b ONLY IF a is nil

@inlinable public func ??= <T>(lhs: inout T?, rhs: T?) { lhs = lhs ?? rhs }

public let not = (!)  // not(x) => !x
