//
//  DataPublisherProvider.swift
//
//  Copyright © 2021 Purgatory Design. Licensed under the MIT License.
//

#if canImport(Combine)

import Combine
import Foundation

@available(iOS 13.0, macOS 10.15, *)
public protocol DataPublisherProvider {

    func dataPublisher(for request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLError>
}

@available(iOS 13.0, macOS 10.15, *)
extension URLSession: DataPublisherProvider {

    public func dataPublisher(for request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLError> {
        dataTaskPublisher(for: request)
            .eraseToAnyPublisher()
    }
}

#endif
