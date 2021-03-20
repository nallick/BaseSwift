//
//  Json.swift
//
//  Copyright © 2020-2021 Purgatory Design. Licensed under the MIT License.
//
//  Inspired by: https://github.com/apple/swift-evolution/blob/master/proposals/0195-dynamic-member-lookup.md
//
//  json["name"]?["first"] as? String becomes: json.name?.first.asString
//

import Foundation

@dynamicMemberLookup
public enum Json: Equatable {

    case array([Json])
    case dictionary([String: Json])
    case double(Double)
    case integer(Int)
    case null
    case string(String)

    public static let malformedJsonError = NSError(domain: NSCocoaErrorDomain, code: 3840)   // this is the error thrown by JSONSerialization.jsonObject() for malformed JSON

    public var asArray: [Json]? {
        switch self {
            case .array(let arrayValue): return arrayValue
            default: return nil
        }
    }

    public var asBool: Bool? {
        switch self {
            case .integer(let intValue): return intValue != 0
            default: return nil
        }
    }

    public var asDictionary: [String: Json]? {
        switch self {
            case .dictionary(let dictionaryValue): return dictionaryValue
            default: return nil
        }
    }

    public var asDouble: Double? {
        switch self {
            case .double(let doubleValue): return doubleValue
            case .integer(let intValue): return Double(intValue)
            default: return nil
        }
    }

    public var asInt: Int? {
        switch self {
            case .integer(let intValue): return intValue
            default: return nil
        }
    }

    public var asString: String? {
        switch self {
            case .double(let doubleValue): return String(doubleValue)
            case .integer(let intValue): return String(intValue)
            case .string(let string): return string
            default: return nil
        }
    }

    public subscript(index: Int) -> Json? {
        guard case .array(let array) = self else { return nil }
        return index < array.count ? array[index] : nil
    }

    public subscript(key: String) -> Json? {
        guard case .dictionary(let dictionary) = self else { return nil }
        return dictionary[key]
    }

    public subscript(dynamicMember member: String) -> Json? {
        guard case .dictionary(let dictionary) = self else { return nil }
        return dictionary[member]
    }

    public init() {
        self = .null
    }

    public init(_ data: Data) throws {
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        try self.init(value: jsonObject)
    }

    private init(value: Any) throws {
        switch value {
            case let intValue as Int:
                self = .integer(intValue)
            case let doubleValue as Double:
                self = .double(doubleValue)
            case let arrayValue as [Any]:
                self = .array(try arrayValue.map { try Json(value: $0) })
            case let dictionaryValue as [String: Any]:
                self = .dictionary(try dictionaryValue.mapValues { try Json(value: $0) })
            case let stringValue as String:
                self = .string(stringValue)
            case _ as NSNull:
                self = .null
            default:
                throw Json.malformedJsonError   // this should never happen
        }
    }
}

extension Optional where Wrapped == Json {

    @inlinable public var asArray: [Json]? {
        self?.asArray
    }

    @inlinable public var asBool: Bool? {
        self?.asBool
    }

    @inlinable public var asDictionary: [String: Json]? {
        self?.asDictionary
    }

    @inlinable public var asDouble: Double? {
        self?.asDouble
    }

    @inlinable public var asInt: Int? {
        self?.asInt
    }

    @inlinable public var asString: String? {
        self?.asString
    }

    @inlinable public subscript(index: Int) -> Json? {
        self?[index]
    }

    @inlinable public subscript(key: String) -> Json? {
        self?[key]
    }
}
