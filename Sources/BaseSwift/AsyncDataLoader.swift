//
//  AsyncDataLoader.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import Foundation

@available(swift 5.5)
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public protocol AsyncDataLoader {

    func data(for request: URLRequest, delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
    func data(from url: URL, delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
    func upload(for request: URLRequest, fromFile fileURL: URL, delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
    func upload(for request: URLRequest, from bodyData: Data, delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
    func download(for request: URLRequest, delegate: (URLSessionTaskDelegate)?) async throws -> (URL, URLResponse)
    func download(from url: URL, delegate: (URLSessionTaskDelegate)?) async throws -> (URL, URLResponse)
    func download(resumeFrom resumeData: Data, delegate: (URLSessionTaskDelegate)?) async throws -> (URL, URLResponse)
}

@available(swift 5.5)
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public extension AsyncDataLoader {

    func data(for request: URLRequest, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse) {
        try await self.data(for: request, delegate: delegate)
    }

    func data(from url: URL, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse) {
        try await self.data(from: url, delegate: delegate)
    }

    func upload(for request: URLRequest, fromFile fileURL: URL, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse) {
        try await self.upload(for: request, fromFile: fileURL, delegate: delegate)
    }

    func upload(for request: URLRequest, from bodyData: Data, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse) {
        try await self.upload(for: request, from: bodyData, delegate: delegate)
    }

    func download(for request: URLRequest, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (URL, URLResponse) {
        try await self.download(for: request, delegate: delegate)
    }

    func download(from url: URL, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (URL, URLResponse) {
        try await self.download(from: url, delegate: delegate)
    }

    func download(resumeFrom resumeData: Data, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (URL, URLResponse) {
        try await self.download(resumeFrom: resumeData, delegate: delegate)
    }
}

@available(swift 5.5)
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension URLSession: AsyncDataLoader {}
