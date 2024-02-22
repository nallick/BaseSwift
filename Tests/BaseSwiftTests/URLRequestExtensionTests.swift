//
//  URLRequestExtensionTests.swift
//  
//  Copyright © 2021-2024 Purgatory Design. All rights reserved.
//

import BaseSwift
import Foundation
import XCTest

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class URLRequestExtensionTests: XCTestCase {

    func testHttpMethodCaseIterableIsExhaustive() {

    // we can't use automatic CaseIterable synthesis outside of the original module,
    // but we can use an exhaustive switch to flag changes at test compile time

        var actualAllCases: [URLRequest.HttpMethod] = []
        for method in URLRequest.HttpMethod.allCases {
            switch method {
                case .get, .put, .post, .patch, .delete, .connect, .trace, .head:   // this list should match the list in allCases below
                    actualAllCases.append(method)
            }
        }

        XCTAssertEqual(actualAllCases, URLRequest.HttpMethod.allCases)
    }

    func testRawValueIsUppercasedEnum() {
        let rawValues = URLRequest.HttpMethod.allCases.map { $0.rawValue }
        let uppercased = URLRequest.HttpMethod.allCases.map { String(describing: $0).uppercased() }
        XCTAssertEqual(rawValues, uppercased)
    }

    func testMethodSetCanBeRetrievedThroughGetAndAsHttpMethod() {
        var urlRequest = URLRequest(url: URL(string: "abc.de")!)
        for method in URLRequest.HttpMethod.allCases {
            urlRequest.method = method
            XCTAssertEqual(urlRequest.method, method)
            XCTAssertEqual(urlRequest.httpMethod, method.rawValue)
        }
    }

    func testMethodCanBeSetThroughInitializer() {
        let expectedCachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        let expectedTimeout: TimeInterval = 111

        for method in URLRequest.HttpMethod.allCases {
            let urlRequest = URLRequest(url: URL(string: "abc.de")!, httpMethod: method, cachePolicy: expectedCachePolicy, timeoutInterval: expectedTimeout)
            XCTAssertEqual(urlRequest.method, method)
            XCTAssertEqual(urlRequest.cachePolicy, expectedCachePolicy)
            XCTAssertEqual(urlRequest.timeoutInterval, expectedTimeout)
        }
    }

    func testBodyAndContentTypeCanBeSetThroughInitializer() {
        let expectedBodyData = "test data".data(using: .utf8)!
        let expectedContentType = "test content"
        let expectedCachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        let expectedTimeout: TimeInterval = 111

        for method in URLRequest.HttpMethod.allCases {
            let urlRequest = URLRequest(url: URL(string: "abc.de")!, httpMethod: method, httpBody: expectedBodyData, contentType: expectedContentType, cachePolicy: expectedCachePolicy, timeoutInterval: expectedTimeout)

            XCTAssertEqual(urlRequest.method, method)
            XCTAssertEqual(urlRequest.httpBody, expectedBodyData)
            XCTAssertEqual(urlRequest[httpHeader: .contentLength], expectedBodyData.count)
            XCTAssertEqual(urlRequest[httpHeader: .contentType], expectedContentType)
            XCTAssertEqual(urlRequest.cachePolicy, expectedCachePolicy)
            XCTAssertEqual(urlRequest.timeoutInterval, expectedTimeout)
        }
    }

    func testJsonBodyCanBeSetThroughInitializer() throws {
        struct JsonTestType: Encodable { let a = 1; let b = "abc" }
        let testElement = JsonTestType()
        let expectedBodyData = try JSONEncoder().encode(testElement)
        let expectedCachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        let expectedTimeout: TimeInterval = 111

        for method in URLRequest.HttpMethod.allCases {
            let urlRequest = try URLRequest(url: URL(string: "abc.de")!, httpMethod: method, jsonBody: testElement, cachePolicy: expectedCachePolicy, timeoutInterval: expectedTimeout)

            XCTAssertEqual(urlRequest.method, method)
            XCTAssertEqual(urlRequest.httpBody, expectedBodyData)
            XCTAssertEqual(urlRequest[httpHeader: .contentLength], expectedBodyData.count)
            XCTAssertEqual(urlRequest[httpHeader: .contentType], "application/json")
            XCTAssertEqual(urlRequest.cachePolicy, expectedCachePolicy)
            XCTAssertEqual(urlRequest.timeoutInterval, expectedTimeout)
        }
    }

    func testHttpHeaderFieldRawValues() {
        XCTAssertEqual(URLRequest.HttpHeaderField.accept.rawValue, "Accept")
        XCTAssertEqual(URLRequest.HttpHeaderField.authorization.rawValue, "Authorization")
        XCTAssertEqual(URLRequest.HttpHeaderField.contentEncoding.rawValue, "Content-Encoding")
        XCTAssertEqual(URLRequest.HttpHeaderField.contentLength.rawValue, "Content-Length")
        XCTAssertEqual(URLRequest.HttpHeaderField.contentType.rawValue, "Content-Type")
        XCTAssertEqual(URLRequest.HttpHeaderField.date.rawValue, "Date")
        XCTAssertEqual(URLRequest.HttpHeaderField.custom("X-Request-ID").rawValue, "X-Request-ID")
    }

    func testHttpHeaderInitializerFindsCorrectCaseInsensitiveBuiltInEnum() {
        for builtInField in URLRequest.HttpHeaderField.allBuiltInCases {
            let rawString = builtInField.rawValue.uppercased()
            let headerField = URLRequest.HttpHeaderField(rawValue: rawString)
            XCTAssertEqual(headerField, builtInField)
        }
    }

    func testHttpHeaderFieldFromStringLiteral() {
        let headerField: URLRequest.HttpHeaderField = "X-Request-ID"
        XCTAssertEqual(headerField, URLRequest.HttpHeaderField.custom("X-Request-ID"))
    }

    func testHttpHeaderFieldSubscript() {
        var urlRequest = URLRequest(url: URL(string: "abc.de")!)
        let testString = "test string"
        let testInteger = 123

        urlRequest[httpHeader: .accept] = testString
        XCTAssertEqual(urlRequest[httpHeader: .accept], testString)
        XCTAssertEqual(urlRequest[httpHeader: .accept], urlRequest.value(forHTTPHeaderField: URLRequest.HttpHeaderField.accept.rawValue))

        urlRequest[httpHeader: .accept] = Optional<String>.none
        XCTAssertEqual(urlRequest[httpHeader: .accept], Optional<String>.none)
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: URLRequest.HttpHeaderField.accept.rawValue), nil)

        urlRequest[httpHeader: .contentLength] = testInteger
        XCTAssertEqual(urlRequest[httpHeader: .contentLength], testInteger)
        XCTAssertEqual(urlRequest[httpHeader: .contentLength], urlRequest.value(forHTTPHeaderField: URLRequest.HttpHeaderField.contentLength.rawValue))

        urlRequest[httpHeader: .contentLength] = Optional<Int>.none
        XCTAssertEqual(urlRequest[httpHeader: .contentLength], Optional<Int>.none)
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: URLRequest.HttpHeaderField.contentLength.rawValue), nil)
    }

    func testHttpHeaderFieldBuiltInCaseIterableIsExhaustive() {

        // we can't use automatic CaseIterable synthesis because of the associated value for the custom case,
        // but we can use an exhaustive switch to flag changes at test compile time

        var actualAllCases: [URLRequest.HttpHeaderField] = []
        for field in URLRequest.HttpHeaderField.allBuiltInCases {
            switch field {
                case .accept, .acceptEncoding, .acceptLanguage, .authorization, .cacheControl, .contentEncoding, .contentLanguage,
                        .contentLength, .contentLocation, .contentType, .date:   // this list should match the list in allBuiltInCases below
                    actualAllCases.append(field)
                case .custom(_): break
            }
        }

        XCTAssertEqual(actualAllCases, URLRequest.HttpHeaderField.allBuiltInCases)
    }

    static var allTests = [
        ("testHttpMethodCaseIterableIsExhaustive", testHttpMethodCaseIterableIsExhaustive),
        ("testRawValueIsUppercasedEnum", testRawValueIsUppercasedEnum),
        ("testMethodSetCanBeRetrievedThroughGetAndAsHttpMethod", testMethodSetCanBeRetrievedThroughGetAndAsHttpMethod),
        ("testMethodCanBeSetThroughInitializer", testMethodCanBeSetThroughInitializer),
        ("testBodyAndContentTypeCanBeSetThroughInitializer", testBodyAndContentTypeCanBeSetThroughInitializer),
        ("testJsonBodyCanBeSetThroughInitializer", testJsonBodyCanBeSetThroughInitializer),
        ("testHttpHeaderFieldRawValues", testHttpHeaderFieldRawValues),
        ("testHttpHeaderInitializerFindsCorrectCaseInsensitiveBuiltInEnum", testHttpHeaderInitializerFindsCorrectCaseInsensitiveBuiltInEnum),
        ("testHttpHeaderFieldFromStringLiteral", testHttpHeaderFieldFromStringLiteral),
        ("testHttpHeaderFieldSubscript", testHttpHeaderFieldSubscript),
        ("testHttpHeaderFieldBuiltInCaseIterableIsExhaustive", testHttpHeaderFieldBuiltInCaseIterableIsExhaustive),
    ]
}

extension URLRequest.HttpMethod: CaseIterable {

    public static var allCases: [URLRequest.HttpMethod] = [.get, .put, .post, .patch, .delete, .connect, .trace, .head]
}
