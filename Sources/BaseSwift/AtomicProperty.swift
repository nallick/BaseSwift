//
//  AtomicProperty.swift
//
//  Copyright © 2020 Purgatory Design. Licensed under the MIT License.
//

@propertyWrapper
public final class Atomic<Value> {
    private let mutex = UnfairLock()
    private var value: Value

    public var projectedValue: Atomic<Value> { self }

    public var wrappedValue: Value {
        get {
            self.mutex.lock()
            defer { self.mutex.unlock() }
            return self.value
        } set {
            self.mutex.lock()
            defer { self.mutex.unlock() }
            self.value = newValue
        }
    }

    public init(wrappedValue: Value) {
        self.value = wrappedValue
    }

    public func performAtomic(_ mutation: (inout Value) -> Void) {
        self.mutex.lock()
        defer { self.mutex.unlock() }
        mutation(&self.value)
    }

    public func performAtomic<Result>(_ operation: (Value) -> Result) -> Result {
        self.mutex.lock()
        defer { self.mutex.unlock() }
        return operation(self.value)
    }
}
