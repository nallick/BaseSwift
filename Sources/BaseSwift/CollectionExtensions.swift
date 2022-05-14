//
//  CollectionExtensions.swift
//
//  Copyright © 2018-2021 Purgatory Design. Licensed under the MIT License.
//

import Foundation

public extension Collection {

    @inlinable var isNotEmpty: Bool {
        return !self.isEmpty
    }

    @inlinable subscript(index offset: Int) -> Self.Index {
        self.index(self.startIndex, offsetBy: offset)
    }
}

public extension Collection where Self: BidirectionalCollection {

    var lastIndex: Index {
        return self.index(before: self.endIndex)
    }

    @inlinable subscript(reverseIndex offset: Int) -> Self.Index {  // collection.subscript[reverseIndex: 0] == collection.lastIndex
        self.index(self.endIndex, offsetBy: -(offset + 1))
    }
}

//  Based on "Swift Style" by Erica Sadun, page 72.
//
//  Provides safe subscript access.
//
public extension Collection where Index == Self.Indices.Iterator.Element {

    subscript(safe index: Self.Index) -> Self.Iterator.Element? {
        guard self.indices.contains(index) else { return nil }
        return self[index]
    }

    subscript(safe index: Self.Index, default defaultValue: Self.Iterator.Element) -> Self.Iterator.Element {
        guard self.indices.contains(index) else { return defaultValue }
        return self[index]
    }
}
