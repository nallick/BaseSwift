//
//  URLRequestExtensions.swift
//
//  Copyright © 2021-2024 Purgatory Design. Licensed under the MIT License.
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLRequest {

    public enum HttpMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
        case connect = "CONNECT"
        case trace = "TRACE"
        case head = "HEAD"
    }

    public var method: HttpMethod? {
        get { httpMethod.flatMap { HttpMethod(rawValue: $0) } }
        set { httpMethod = newValue?.rawValue }
    }

    public init(url: URL, httpMethod: HttpMethod, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, timeoutInterval: TimeInterval = 60.0) {
        self.init(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        self.httpMethod = httpMethod.rawValue
    }

    public init(url: URL, httpMethod: HttpMethod, httpBody: Data?, contentType: String, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, timeoutInterval: TimeInterval = 60.0) {
        self.init(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        self.httpMethod = httpMethod.rawValue
        self.httpBody = httpBody
        self[httpHeader: .contentLength] = httpBody?.count
        self[httpHeader: .contentType] = contentType
    }

    public init<Body: Encodable>(url: URL, httpMethod: HttpMethod, jsonBody: Body, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, timeoutInterval: TimeInterval = 60.0) throws {
        let body = try JSONEncoder().encode(jsonBody)
        self.init(url: url, httpMethod: httpMethod, httpBody: body, contentType: "application/json", cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
}

extension URLRequest {

    public enum HttpHeaderField: Equatable, Hashable, RawRepresentable, ExpressibleByStringLiteral {

        public typealias RawValue = String

        public var rawValue: String {
            if case .custom(let value) = self { return value }
            return self.kebobCaseRawValue ?? "\(self)".capitalized
        }

        public init(rawValue: String) {
            for builtInCase in Self.allBuiltInCases {
                if rawValue.caseInsensitiveCompare(builtInCase.rawValue) == .orderedSame {
                    self = builtInCase
                    return
                }
            }

            self = .custom(rawValue)
        }

        public init(stringLiteral value: StringLiteralType) {
            self.init(rawValue: value)
        }

        case accept, acceptEncoding, acceptLanguage, authorization, cacheControl
        case contentEncoding, contentLanguage, contentLength, contentLocation, contentType, date
        case custom(String)

        private var kebobCaseRawValue: String? {
            switch self {
                case .acceptEncoding: return "Accept-Encoding"
                case .acceptLanguage: return "Accept-Language"
                case .cacheControl: return "Cache-Control"
                case .contentEncoding: return "Content-Encoding"
                case .contentLanguage: return "Content-Language"
                case .contentLength: return "Content-Length"
                case .contentLocation: return "Content-Location"
                case .contentType: return "Content-Type"
                default: return nil
            }
        }

        public static let allBuiltInCases: [Self] = [.accept, .acceptEncoding, .acceptLanguage, .authorization, .cacheControl, .contentEncoding, .contentLanguage, .contentLength, .contentLocation, .contentType, .date]
    }

    public subscript(httpHeader field: HttpHeaderField) -> String? {
        get { return self.value(forHTTPHeaderField: field.rawValue) }
        set(value) { self.setValue(value, forHTTPHeaderField: field.rawValue) }
    }

    public subscript(httpHeader field: HttpHeaderField) -> Int? {
        get {
            guard let stringValue = self.value(forHTTPHeaderField: field.rawValue) else { return nil }
            return Int(stringValue)
        }
        set(value) {
            let stringValue = value.map { String($0) }
            self.setValue(stringValue, forHTTPHeaderField: field.rawValue)
        }
    }
}
