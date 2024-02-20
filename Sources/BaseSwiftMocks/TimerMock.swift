//
//  TimerMock.swift
//
//  Copyright © 2019-2024 Purgatory Design. Licensed under the MIT License.
//

import BaseSwift
import Foundation

open class MockTimer: TimerType {
    public var fireDate: Date = Date.distantFuture
    public var timeInterval: TimeInterval = 0.0
    public var repeats = false
    public var target: Any?
    public var block: ((TimerType) -> Void)?
    public var invalidatedCount = 0
    public var hasBeenScheduled = false

#if canImport(ObjectiveC)
    public var selector: Selector?
#endif

    public init() {}

    open func fire() {
#if canImport(ObjectiveC)
        if let target = self.target, let selector = self.selector {
            _ = (target as AnyObject).perform(selector)
        }
#endif

        self.block?(self)
    }

    open func invalidate() {
        self.invalidatedCount += 1
    }
}

open class MockTimerFactory: TimerFactory {
    public static var timers: [MockTimer] = []

    open class func scheduledOneShotTimer(withTimeInterval interval: TimeInterval, block: @escaping (TimerType) -> Void) -> TimerType {
        let result = self.timers.first ?? MockTimer()

        result.fireDate = Date(timeIntervalSinceNow: interval)
        result.timeInterval = interval
        result.block = block
        result.repeats = false
        result.hasBeenScheduled = true

        self.timers = Array(self.timers.dropFirst())
        return result
    }

    open class func scheduledRepeatingTimer(withTimeInterval interval: TimeInterval, block: @escaping (TimerType) -> Void) -> TimerType {
        let result = self.timers.first ?? MockTimer()

        result.fireDate = Date(timeIntervalSinceNow: interval)
        result.timeInterval = interval
        result.block = block
        result.repeats = true
        result.hasBeenScheduled = true

        self.timers = Array(self.timers.dropFirst())
        return result
    }

 #if canImport(ObjectiveC)

   open class func scheduledOneShotTimer(timeInterval: TimeInterval, target: Any, selector: Selector) -> TimerType {
        let result = self.timers.first ?? MockTimer()

        result.fireDate = Date(timeIntervalSinceNow: timeInterval)
        result.timeInterval = timeInterval
        result.target = target
        result.selector = selector
        result.repeats = false
        result.hasBeenScheduled = true

        self.timers = Array(self.timers.dropFirst())
        return result
    }

    open class func scheduledRepeatingTimer(timeInterval: TimeInterval, target: Any, selector: Selector) -> TimerType {
        let result = self.timers.first ?? MockTimer()

        result.fireDate = Date(timeIntervalSinceNow: timeInterval)
        result.timeInterval = timeInterval
        result.target = target
        result.selector = selector
        result.repeats = true
        result.hasBeenScheduled = true

        self.timers = Array(self.timers.dropFirst())
        return result
    }
#endif

}

extension Timer {
    public static let mockFactory: TimerFactory.Type = MockTimerFactory.self
}
