//
//  Reference.swift
//
//  From: https://www.swiftbysundell.com/tips/combining-dynamic-member-lookup-with-key-paths/
//
//  Boxes a value type in a class to make it a reference type.
//
//  For example:
//    struct Example { var aProperty = 123 }
//
//    let reference = MutableReference(Example())
//    let initialValue = reference.aProperty
//    reference.aProperty = 456
//

@dynamicMemberLookup
public final class Reference<Value> {

    public let value: Value

    @inlinable public init(_ value: Value) {
        self.value = value
    }

    @inlinable public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T {
        self.value[keyPath: keyPath]
    }
}

@dynamicMemberLookup
public final class MutableReference<Value> {

    public var value: Value

    public init(_ value: Value) {
        self.value = value
    }

    @inlinable public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T {
        self.value[keyPath: keyPath]
    }

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        get { self.value[keyPath: keyPath] }
        set { self.value[keyPath: keyPath] = newValue }
    }
}
