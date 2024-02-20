//
//  URLProtocolMock.swift
//
//  Copyright © 2019-2024 Purgatory Design.  Licensed under the MIT License.
//
//  See WWDC 2018, Testing Tips & Tricks, 9:15
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

open class URLProtocolMock: URLProtocol {
    public typealias RequestResponse = (response: HTTPURLResponse?, data: Data?)
    public typealias RequestHandler = (URLRequest) throws -> RequestResponse

    public static var requestHandler: RequestHandler?	// function need not declare throws

    open class var urlSession: URLSession { Self.makeURLSession(for: Self.self) }

	open class func makeURLSession(for protocolClass: URLProtocolMock.Type) -> URLSession {
		let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [protocolClass]
		return URLSession(configuration: configuration)
	}

	open func fulfill(request: URLRequest) throws -> (response: HTTPURLResponse?, data: Data?) {
		guard let requestHandler = URLProtocolMock.requestHandler else {
			fatalError("Mock must override URLProtocolMock.fulfill(request:) or provide a request handler via URLProtocolMock.requestHandler.")
		}

		return try requestHandler(request)
	}

    /// Must be instantiated via URLSession.
    ///
#if canImport(ObjectiveC)
    private override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)
    }
#endif
}

#if canImport(ObjectiveC)

extension URLProtocolMock {  // override URLProtocol

    open override class func canInit(with request: URLRequest) -> Bool { true }

    open override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    open override func startLoading() {
        guard let client = self.client else { return }

        do {
            let (response, data) = try self.fulfill(request: self.request)
            if let response = response { client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed) }
            if let data = data { client.urlProtocol(self, didLoad: data) }
        } catch {
            client.urlProtocol(self, didFailWithError: error)
        }

        client.urlProtocolDidFinishLoading(self)
    }

    open override func stopLoading() {}
}

#endif
