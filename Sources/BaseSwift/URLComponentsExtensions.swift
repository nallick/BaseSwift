//
//  URLComponentsExtensions.swift
//
//  Copyright © 2021 Purgatory Design. Licensed under the MIT License.
//

import Foundation

extension URLComponents {

    public init?(string: String, queryItems: [URLQueryItem]) {
        self.init(string: string)
        self.queryItems = queryItems
    }

    public init?(url: URL, resolvingAgainstBaseURL resolve: Bool, queryItems: [URLQueryItem]) {
        self.init(url: url, resolvingAgainstBaseURL: resolve)
        self.queryItems = queryItems
    }
}
