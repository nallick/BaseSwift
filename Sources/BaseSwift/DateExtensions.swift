//
//  DateExtensions.swift
//
//  Copyright © 2017-2021 Purgatory Design. Licensed under the MIT License.
//

import Foundation

public extension Date {

    init?(iso8601 string: String) {
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: string) else { return nil }
        self = date
    }

    @inlinable static var now: Date { Date() }

    static var yesterday: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: .now)!
    }

    @inlinable static var today: Date { .now }

    static var tomorrow: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: .now)!
    }

    var dayOfWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }

    var iso8601: String {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.string(from: self)
    }

    func iso8601(timeZone: TimeZone, formatOptions: ISO8601DateFormatter.Options = []) -> String {
        ISO8601DateFormatter.string(from: self, timeZone: timeZone, formatOptions: formatOptions)
    }
}
