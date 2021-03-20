//
//  UserDefaultProperty.swift
//
//  Copyright © 2020-2021 Purgatory Design. Licensed under the MIT License.
//

import Foundation

@propertyWrapper
public struct UserDefault<Value> {
    public let key: String
    public let defaultValue: Value
    public let userDefaults: UserDefaults

    public var projectedValue: UserDefault<Value> { self }

    public var wrappedValue: Value {
        get {
            self.userDefaults.object(forKey: key) as? Value ?? defaultValue
        } set {
            self.userDefaults.set(newValue, forKey: key)
        }
    }

    public init(key: String, defaultValue: Value, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}
