//
//  NSObjectTestExtensions.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

#if canImport(ObjectiveC)

import Foundation

extension NSObject {

    /// Instantiates and potentially initializes a raw object derived from NSObject directly via the Objective-C runtime.
    ///
    /// - Parameters
    ///     - classType: The class type to instantiate.
    ///     - properties: The properties to initialize the new object with, provided the object is key-value coding-compliant.
    /// - Returns: The instantiated object (or nil).
    ///
    /// - Note: This uses private system API so should only be used in test targets. The resulting objects are probably not fully initialized and may behave erratically.
    ///
    public static func new<Class: NSObject>(_ classType: Class.Type, properties: [String: Any?] = [:]) -> Class? {
        let className = String(describing: Class.self)
        let classObject = objc_getClass(className) as? NSObject
        guard let result = classObject?.perform(NSSelectorFromString("new")).takeRetainedValue() as? Class else { return nil }
        for (key, value) in properties { result.setValue(value, forKey: key) }
        return result
    }
}

#endif
