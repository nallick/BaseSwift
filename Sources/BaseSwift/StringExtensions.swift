//
//  StringExtensions.swift
//
//  Copyright © 2018-2021 Purgatory Design. Licensed under the MIT License.
//

import Foundation

public extension String {

    @inlinable var isEmptyOrWhitespace: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    @inlinable var isNotEmptyOrWhitespace: Bool {
        return !self.isEmptyOrWhitespace
    }

    func leftTrimmingCharacters(in characterSet: CharacterSet) -> String {
        guard let range = self.rangeOfCharacter(from: characterSet.inverted) else { return "" }
        return String(self[range.lowerBound ..< self.endIndex])
    }

#if canImport(ObjectiveC)

    init<Value>(_ value: Value, decimalPlaces: Int, trailingZeros: Bool = false) where Value: Numeric {
        guard let numberValue = value as? NSNumber else { fatalError("Can't convert \(value) to NSNumber") }

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = decimalPlaces
        numberFormatter.minimumFractionDigits = trailingZeros ? decimalPlaces : 0
        self = numberFormatter.string(from: numberValue) ?? ""
    }

#endif
}
