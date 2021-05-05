//
//  URLRequestExtensionTests.swift
//  
//  Copyright © 2021 Purgatory Design. All rights reserved.
//

import Foundation
import XCTest

final class URLRequestExtensionTests: XCTestCase {

    func testCaseIterableIsExhaustive() {

    // we can't use automatic CaseIterable synthesis outside of the original module, but we can use an exhaustive switch to flag changes

        var actualAllCased: [URLRequest.HttpMethod] = []
        for method in URLRequest.HttpMethod.allCases {
            switch method {
                case .get, .put, .post, .patch, .delete, .connect, .trace, .head:   // this list should match the list in allCases below
                    actualAllCased.append(method)
            }
        }

        XCTAssertEqual(actualAllCased, URLRequest.HttpMethod.allCases)
    }

    func testRawValueIsUppercasedEnum() {
        let rawValues = URLRequest.HttpMethod.allCases.map { $0.rawValue }
        let uppercased = URLRequest.HttpMethod.allCases.map { String(describing: $0).uppercased() }
        XCTAssertEqual(rawValues, uppercased)
    }

    func testMethodSetCanBeRetreavedThroughGetAndAsHttpMethod() {
        var urlRequest = URLRequest(url: URL(string: "abc.de")!)
        for method in URLRequest.HttpMethod.allCases {
            urlRequest.method = method
            XCTAssertEqual(urlRequest.method, method)
            XCTAssertEqual(urlRequest.httpMethod, method.rawValue)
        }
    }
}

extension URLRequest.HttpMethod: CaseIterable {

    public static var allCases: [URLRequest.HttpMethod] = [.get, .put, .post, .patch, .delete, .connect, .trace, .head]
}
