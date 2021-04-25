//
//  MockURLResponses.swift
//
//  Copyright © 2021 Purgatory Design. Licensed under the MIT License.
//

import Foundation

extension URLResponse {

    public static func mockHttpResponse(statusCode: Int, httpVersion: String? = nil, headerFields: [String : String]? = nil) -> HTTPURLResponse {
        HTTPURLResponse(url: URL(string: "abc.de")!, statusCode: statusCode, httpVersion: httpVersion, headerFields: headerFields)!
    }

    public static var mockHttpSuccess: HTTPURLResponse {
        self.mockHttpResponse(statusCode: 200)
    }

    public static var mockHttpFailure: HTTPURLResponse {
        self.mockHttpResponse(statusCode: 500)
    }
}
