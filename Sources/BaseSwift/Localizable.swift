//
//  Localizable.swift
//
//  Copyright © 2020-2021 Purgatory Design. Licensed under the MIT License.
//

#if canImport(ObjectiveC)

import Foundation

// MARK: Localizable

public protocol Localizable {

	var localizationKey: String { get }
	static var localizationTable: LocalizationTable? { get }
	static var localizationBundle: Bundle { get }
	static var localizationKeyOperator: (Self) -> String { get }
}

public extension Localizable {

	@inlinable var localizationKey: String {
		Self.localizationKeyOperator(self)
	}

	@inlinable static var localizationTable: LocalizationTable? {
		nil
	}

	@inlinable static var localizationBundle: Bundle {
		.main
	}

	@inlinable static var localizationKeyOperator: (Self) -> String {
		{ String.localizationKeyOperator(String(describing: $0)) }
	}

	@inlinable func localized(table: LocalizationTable? = nil, bundle: Bundle? = nil, value: String = "", comment: String = "") -> String {
		NSLocalizedString(self.localizationKey, tableName: table?.name ?? Self.localizationTable?.name, bundle: bundle ?? Self.localizationBundle, value: value, comment: comment)
	}

	@inlinable func callAsFunction(table: LocalizationTable? = nil, bundle: Bundle? = nil, value: String = "", comment: String = "") -> String {
		self.localized(table: table, bundle: bundle, value: value, comment: comment)
	}
}

// MARK: LocalizationTable

public protocol LocalizationTable {

	var name: String { get }
}

public extension LocalizationTable {

	@inlinable var name: String {
		String(describing: self).capitalized
	}

	@inlinable func localized(_ key: String, bundle: Bundle = .main, value: String = "", comment: String = "") -> String {
		key.localized(tableName: self.name, bundle: bundle, value: value, comment: comment)
	}

	@inlinable func callAsFunction(_ key: String, bundle: Bundle = .main, value: String = "", comment: String = "") -> String {
		self.localized(key, bundle: bundle, value: value, comment: comment)
	}
}

// MARK: String

public extension String {

	static var localizationKeyOperator: (String) -> String = { "*\($0)*" }		// the default key pattern for the string "key" is "*key*"

	@inlinable func localized(tableName: String? = nil, bundle: Bundle = .main, value: String = "", comment: String = "") -> String {
		NSLocalizedString(Self.localizationKeyOperator(self), tableName: tableName, bundle: bundle, value: value, comment: comment)
	}

	@inlinable func localized(table: LocalizationTable, bundle: Bundle = .main, value: String = "", comment: String = "") -> String {
		self.localized(tableName: table.name, bundle: bundle, value: value, comment: comment)
	}
}

#endif
