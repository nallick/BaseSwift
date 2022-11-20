//
//  MockAsyncDataLoader.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import BaseSwift
import Foundation

@available(swift 5.5)
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
open class MockAsyncDataLoader: AsyncDataLoader {

    public var response: URLResponse
    public var responseBody: Data
    public var responseError: URLError?
    public var responseUrl: URL
    public var isCancelled: Bool

    public var responses: [URLResponse]?
    public var responseBodies: [Data]?
    public var responseErrors: [URLError]?
    public var responseUrls: [URL]?
    public var cancelations: [Bool]?

    public var requests: [URLRequest] = []
    public var resumeData: [Data] = []
    public var urls: [URL] = []

    public init(response: URLResponse = URLResponse(), responseBody: Data = Data(), responseError: URLError? = nil, responseUrl: URL = URL(string: "/")!, isCancelled: Bool = false) {
        self.response = response
        self.responseBody = responseBody
        self.responseError = responseError
        self.responseUrl = responseUrl
        self.isCancelled = isCancelled
    }

    public var nextResponse: URLResponse {
        guard let responseList = self.responses, let firstResponse = responseList.first else { return self.response }
        self.responses = Array(responseList.dropFirst())
        return firstResponse
    }

    public var nextResponseBody: Data {
        guard let bodyList = self.responseBodies, let firstBody = bodyList.first else { return self.responseBody }
        self.responseBodies = Array(bodyList.dropFirst())
        return firstBody
    }

    public var nextResponseUrl: URL {
        guard let urlList = self.responseUrls, let firstUrl = urlList.first else { return self.responseUrl }
        self.responseUrls = Array(urlList.dropFirst())
        return firstUrl
    }

    public var nextIsCancelled: Bool {
        guard let cancelationList = self.cancelations, let firstIsCancelled = cancelationList.first else { return self.isCancelled }
        self.cancelations = Array(cancelationList.dropFirst())
        return firstIsCancelled
    }

    public var nextError: Error? {
        if self.nextIsCancelled { return CancellationError() }
        guard let errorList = self.responseErrors, let firstError = errorList.first else { return self.responseError }
        self.responseErrors = Array(errorList.dropFirst())
        return firstError
    }

    public func data(for request: URLRequest, delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        self.requests.append(request)
        if let error = self.nextError { throw error }
        return (self.nextResponseBody, self.nextResponse)
    }

    public func data(from url: URL, delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        self.urls.append(url)
        if let error = self.nextError { throw error }
        return (self.nextResponseBody, self.nextResponse)
    }

    public func upload(for request: URLRequest, fromFile fileURL: URL, delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        self.requests.append(request)
        if let error = self.nextError { throw error }
        return (self.nextResponseBody, self.nextResponse)
    }

    public func upload(for request: URLRequest, from bodyData: Data, delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        self.requests.append(request)
        if let error = self.nextError { throw error }
        return (self.nextResponseBody, self.nextResponse)
    }

    public func download(for request: URLRequest, delegate: (URLSessionTaskDelegate)?) async throws -> (URL, URLResponse) {
        self.requests.append(request)
        if let error = self.nextError { throw error }
        return (self.nextResponseUrl, self.nextResponse)
    }

    public func download(from url: URL, delegate: (URLSessionTaskDelegate)?) async throws -> (URL, URLResponse) {
        self.urls.append(url)
        if let error = self.nextError { throw error }
        return (self.nextResponseUrl, self.nextResponse)
    }

    public func download(resumeFrom resumeData: Data, delegate: (URLSessionTaskDelegate)?) async throws -> (URL, URLResponse) {
        self.resumeData.append(resumeData)
        if let error = self.nextError { throw error }
        return (self.nextResponseUrl, self.nextResponse)
    }
}
