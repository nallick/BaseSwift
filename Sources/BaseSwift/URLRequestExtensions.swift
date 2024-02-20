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
}
