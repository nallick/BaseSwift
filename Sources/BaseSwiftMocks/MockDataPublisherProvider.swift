//
//  MockDataPublisherProvider.swift
//
//  Copyright © 2021-2022 Purgatory Design. Licensed under the MIT License.
//

#if canImport(Combine)

import BaseSwift
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
open class MockDataPublisherProvider: DataPublisherProvider {

    public var response: URLResponse
    public var responseBody: Data
    public var responseError: URLError?

    public var responses: [URLResponse]?
    public var responseBodies: [Data]?
    public var responseErrors: [URLError]?

    public var requests: [URLRequest] = []

    public init(response: URLResponse = URLResponse(), responseBody: Data = Data(), responseError: URLError? = nil) {
        self.response = response
        self.responseBody = responseBody
        self.responseError = responseError
    }

    open var nextResponse: URLResponse {
        guard let responseList = self.responses, let firstResponse = responseList.first else { return self.response }
        self.responses = Array(responseList.dropFirst())
        return firstResponse
    }

    open var nextResponseBody: Data {
        guard let bodyList = self.responseBodies, let firstBody = bodyList.first else { return self.responseBody }
        self.responseBodies = Array(bodyList.dropFirst())
        return firstBody
    }

    open var nextError: URLError? {
        guard let errorList = self.responseErrors, let firstError = errorList.first else { return self.responseError }
        self.responseErrors = Array(errorList.dropFirst())
        return firstError
    }

    open func dataPublisher(for request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLError> {
        self.requests.append(request)

        if let error = self.nextError {
            return Fail(outputType: URLSession.DataTaskPublisher.Output.self, failure: error)
                .eraseToAnyPublisher()
        }

        return Just((self.nextResponseBody, self.nextResponse))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}

#endif
