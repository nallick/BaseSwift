//
//  DataPublisherProvider.swift
//
//  Copyright © 2021-2022 Purgatory Design. Licensed under the MIT License.
//

#if canImport(Combine)

import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public protocol DataPublisherProvider {

    func dataPublisher(for request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLError>
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension URLSession: DataPublisherProvider {

    public func dataPublisher(for request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLError> {
        dataTaskPublisher(for: request)
            .eraseToAnyPublisher()
    }
}

#endif
