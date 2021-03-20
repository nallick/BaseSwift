//
//  KeychainItem.swift
//
//  Copyright © 2017-2021 Purgatory Design. Licensed under the MIT License.
//
//    Based on KeychainPasswordItem from GenericKeychain sample code.
//    Copyright (C) 2016 Apple Inc. All Rights Reserved.
//

#if canImport(ObjectiveC)

import Foundation

public struct KeychainItem {

    // MARK: Types
    public enum KeychainError: Error {
        case itemNotFound
        case unexpectedItemData
        case unexpectedStringData
        case unexpectedError(OSStatus)
    }

    // MARK: Properties
    public let service: String
    public let accessGroup: String?
    public private(set) var account: String

    // MARK: Intialization
    public init(service: String, account: String, accessGroup: String? = nil) {
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }

    // MARK: Keychain access
    public func restore() throws -> Data {
        // Build a query to find the item that matches the service, account and access group.
        var query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue

        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { throw KeychainError.itemNotFound }
        guard status == noErr else { throw KeychainError.unexpectedError(status) }

        // Parse the data from the query result.
        guard let existingItem = queryResult as? [String : AnyObject],
              let result = existingItem[kSecValueData as String] as? Data
        else { throw KeychainError.unexpectedItemData }

        return result
    }

    public func restoreString() throws -> String {
        // Parse the string from the query result.
        let keychainData = try restore()
        guard let result = String(data: keychainData, encoding: String.Encoding.utf8)
        else { throw KeychainError.unexpectedStringData }

        return result
    }

    public func archive(data: Data) throws {
        do {
            // Check for an existing item in the keychain.
            try _ = restore()

            // Update the existing item with the new data.
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = data as AnyObject?

            let query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)

            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unexpectedError(status) }
        }
        catch KeychainError.itemNotFound {
            // No item was found in the keychain. Create a dictionary to save as a new keychain item.
            var newItem = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            newItem[kSecValueData as String] = data as AnyObject?

            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)

            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unexpectedError(status) }
        }
    }

    public func archive(string: String) throws {
        // Encode the string into a Data object and archive it.
        let encodedString = string.data(using: String.Encoding.utf8)!
        try archive(data: encodedString)
    }

    public mutating func renameAccount(_ newAccountName: String) throws {
        // Try to update an existing item with the new account name.
        var attributesToUpdate = [String : AnyObject]()
        attributesToUpdate[kSecAttrAccount as String] = newAccountName as AnyObject?

        let query = KeychainItem.keychainQuery(withService: service, account: self.account, accessGroup: accessGroup)
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)

        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unexpectedError(status) }

        self.account = newAccountName
    }

    public func delete() throws {
        // Delete the existing item from the keychain.
        let query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)

        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unexpectedError(status) }
    }

    public static func keychainItems(forService service: String, accessGroup: String? = nil) throws -> [KeychainItem] {
        // Build a query for all items that match the service and access group.
        var query = KeychainItem.keychainQuery(withService: service, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanFalse

        // Fetch matching items from the keychain.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        // If no items were found, return an empty array.
        guard status != errSecItemNotFound else { return [] }

        // Throw an error if an unexpected status was returned.
        guard status == noErr else { throw KeychainError.unexpectedError(status) }

        // Cast the query result to an array of dictionaries.
        guard let resultData = queryResult as? [[String : AnyObject]] else { throw KeychainError.unexpectedItemData }

        // Create a `KeychainItem` for each dictionary in the query result.
        var keychainItems = [KeychainItem]()
        for result in resultData {
            guard let account  = result[kSecAttrAccount as String] as? String else { throw KeychainError.unexpectedItemData }

            let keychainItem = KeychainItem(service: service, account: account, accessGroup: accessGroup)
            keychainItems.append(keychainItem)
        }

        return keychainItems
    }

    // MARK: Convenience
    private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?

        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }

        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }

        return query
    }
}

#endif
