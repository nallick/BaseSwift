//
//  BackgroundTask.swift
//
//  Copyright © 2019-2021 Purgatory Design. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public final class BackgroundTask {
	private var identifier = UIBackgroundTaskIdentifier.invalid

    public init(name: String = "", expirationHandler: (() -> Void)? = nil) {
		self.identifier = UIApplication.shared.beginBackgroundTask(withName: name) { [weak self] in
			self?.end()
			expirationHandler?()
		}
	}

	deinit { self.end() }

	public func end() {
		guard self.identifier != UIBackgroundTaskIdentifier.invalid else { return }
		UIApplication.shared.endBackgroundTask(self.identifier)
		self.identifier = UIBackgroundTaskIdentifier.invalid
	}
}

#else

public struct BackgroundTask {

    public init(name: String = "", expirationHandler: (() -> Void)? = nil) {}

    public func end() {}
}

#endif
