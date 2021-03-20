//
//  NSObjectAssociatedObject.swift
//
//  Copyright © 2017-2021 Purgatory Design. Licensed under the MIT License.
//
//  Based on Stack Overflow post from HepaKKes: http://stackoverflow.com/a/29662565/8047
//

#if canImport(ObjectiveC)

import Foundation

@nonobjc public extension NSObject {

    /// Get an associated object from this object.
    ///
    /// - Parameter key: The associated object key.
    /// - Returns: The associated object.
    ///
    func associatedObject<Element>(forKey key: UnsafeRawPointer) -> Element? {
        let associatedObject = objc_getAssociatedObject(self, key)
        if let value = associatedObject as? Element {
            return value
        } else if let reference = associatedObject as? Reference<Element> {
            return reference.value
        }
        return nil
    }

    /// Set an associated object of this object.
    ///
    /// - Parameters:
    ///   - value: The associated object value.
    ///   - key: The associated object key.
    ///   - policy: The object's Obj-C runtime policy.
    ///
    func setAssociatedObject<Element>(_ value: Element, forKey key: UnsafeRawPointer, policy: objc_AssociationPolicy) {
        if let objectValue = value as? NSObject {
            objc_setAssociatedObject(self, key, objectValue, policy)
        } else {
            objc_setAssociatedObject(self, key, Reference(value), policy)
        }
    }

    /// Remove an associated object from this object.
    ///
    /// - Parameters:
    ///   - key: The associated object key.
    ///
    func removeAssociatedObject(forKey key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, nil, .OBJC_ASSOCIATION_ASSIGN)
    }
}

#endif
