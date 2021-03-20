//
//  TimerFactory.swift
//
//  Copyright © 2019-2021 Purgatory Design. Licensed under the MIT License.
//

import Foundation

public protocol TimerType: AnyObject {

    var fireDate: Date { get set }
    var timeInterval: TimeInterval { get }

    func invalidate()
}

extension Timer: TimerType {}

public protocol TimerFactory {

    @available(iOS 10.0, macOS 10.12, *)
    static func scheduledOneShotTimer(withTimeInterval: TimeInterval, block: @escaping (TimerType) -> Void) -> TimerType
    @available(iOS 10.0, macOS 10.12, *)
    static func scheduledRepeatingTimer(withTimeInterval: TimeInterval, block: @escaping (TimerType) -> Void) -> TimerType

    #if canImport(ObjectiveC)
    static func scheduledOneShotTimer(timeInterval: TimeInterval, target: Any, selector: Selector) -> TimerType
    static func scheduledRepeatingTimer(timeInterval: TimeInterval, target: Any, selector: Selector) -> TimerType
    #endif
}

extension Timer: TimerFactory {

    @inlinable @available(iOS 10.0, macOS 10.12, *)
    public class func scheduledOneShotTimer(withTimeInterval interval: TimeInterval, block: @escaping (TimerType) -> Void) -> TimerType {
        self.scheduledTimer(withTimeInterval: interval, repeats: false, block: block)
    }

    @inlinable @available(iOS 10.0, macOS 10.12, *)
    public class func scheduledRepeatingTimer(withTimeInterval interval: TimeInterval, block: @escaping (TimerType) -> Void) -> TimerType {
        self.scheduledTimer(withTimeInterval: interval, repeats: true, block: block)
    }

    #if canImport(ObjectiveC)
    @inlinable public class func scheduledOneShotTimer(timeInterval: TimeInterval, target: Any, selector: Selector) -> TimerType {
        self.scheduledTimer(timeInterval: timeInterval, target: target, selector: selector, userInfo: nil, repeats: false)
    }

    @inlinable public class func scheduledRepeatingTimer(timeInterval: TimeInterval, target: Any, selector: Selector) -> TimerType {
        self.scheduledTimer(timeInterval: timeInterval, target: target, selector: selector, userInfo: nil, repeats: true)
    }
    #endif
}

extension Timer {
    public static let factory: TimerFactory.Type = Timer.self
}

