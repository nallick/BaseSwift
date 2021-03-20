//
//  DefaultClassDescription.swift
//
//  Copyright © 2018 Purgatory Design. Licensed under the MIT License.
//  Based on DefaultReflectable in "Swift Style" by Erica Sadun, page 186.
//
//    Adds a default description and debug description to a class via reflection.
//

import Foundation

public protocol DefaultClassDescription: CustomStringConvertible, CustomDebugStringConvertible  {}

extension DefaultClassDescription {

    public var description: String {
        let mirror = Mirror(reflecting: self)
        let chunks = mirror.children.map { (label, value) -> String in
            guard let label = label else { return String(describing: value) }
            return value is String ? "\(label): \"\(value)\"" : "\(label): \(value)"
        }

        return chunks.isEmpty ? "\(self)" : "\(mirror.subjectType)(\(chunks.joined(separator: ", ")))"
    }

    public var debugDescription: String {
        return self.description
    }
}

/*
 Example:

 class Test: DefaultClassDescription { let a = 1; let b = "two" }
 print(Test()) // Test(a: 1, b: "two")
*/
