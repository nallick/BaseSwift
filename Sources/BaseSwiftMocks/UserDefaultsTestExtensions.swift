//
//  UserDefaultsTestExtensions.swift
//
//  Copyright © 2021 Purgatory Design. Licensed under the MIT License.
//

import Foundation

extension UserDefaults {
    public static let testSuite = "__UserDefaultsTestSuite__"

    public static var test: UserDefaults {
        let suiteName = (Bundle.main.bundleIdentifier ?? "") + self.testSuite
        return UserDefaults(suiteName: suiteName)!
    }

    public func removeAllValues() {
        let keys = self.dictionaryRepresentation().keys
        keys.forEach { self.removeObject(forKey: $0) }
    }
}
