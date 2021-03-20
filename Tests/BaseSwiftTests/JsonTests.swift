//
//  JsonTests.swift
//
//  Copyright © 2020 Purgatory Design. Licensed under the MIT License.
//

import BaseSwift
import XCTest

final class JsonTests: XCTestCase {
    let jsonStr =
        """
        {
            "integerKey": 1,
            "doubleKey": 2.3,
            "stringKey": "test string",
            "recordKey": { "one": 1, "two": 2, "three": 3 },
            "arrayKey": [1, 2, 3],
            "nullKey": null
        }
        """
    var jsonData: Data! {
        jsonStr.data(using: .utf8)
    }

    func testEmptyInitializerCreatesNullJson() {
        let json = Json()
        XCTAssertEqual(json, .null)
    }

    func testNull() throws {
        let json = try Json(jsonData)
        XCTAssertEqual(json.nullKey, .null)
    }

    func testNumbers() throws {
        let json = try Json(jsonData)

        XCTAssertEqual(json.integerKey.asBool, true)
        XCTAssertEqual(json.integerKey.asInt, 1)
        XCTAssertEqual(json.doubleKey.asDouble, 2.3)
    }

    func testString() throws {
        let json = try Json(jsonData)

        XCTAssertEqual(json.stringKey.asString, "test string")
        XCTAssertEqual(json.doubleKey.asString, "2.3")
        XCTAssertEqual(json.integerKey.asString, "1")
    }

    func testArray() throws {
        let json = try Json(jsonData)

        let actualArray = json.arrayKey.asArray?.map {
            $0.asInt ?? 0
        }

        XCTAssertEqual(actualArray, [1, 2, 3])
    }

    func testArraySubscript() throws {
        let json = try Json(jsonData)

        var actualArray: [Int] = []
        for index in 0 ..< json.arrayKey.asArray!.count {
            let element = json.arrayKey[index]
            actualArray.append(element.asInt ?? 0)
        }

        XCTAssertEqual(actualArray, [1, 2, 3])
    }

    func testDictionaryDynamicMembers() throws {
        let json = try Json(jsonData)

        XCTAssertEqual(json.recordKey?.one.asInt, 1)
        XCTAssertEqual(json.recordKey?.two.asInt, 2)
        XCTAssertEqual(json.recordKey?.three.asInt, 3)
    }

    func testDictionaryAsDictionary() throws {
        let json = try Json(jsonData)

        XCTAssertEqual(json.recordKey.asDictionary?["one"].asInt, 1)
        XCTAssertEqual(json.recordKey.asDictionary?["two"].asInt, 2)
        XCTAssertEqual(json.recordKey.asDictionary?["three"].asInt, 3)
    }

    func testDictionarySubscript() throws {
        let json = try Json(jsonData)

        XCTAssertEqual(json.recordKey["one"].asInt, 1)
        XCTAssertEqual(json.recordKey["two"].asInt, 2)
        XCTAssertEqual(json.recordKey["three"].asInt, 3)
    }

    func testBadJsonThrowsExpectedError() {
        let badJson = "bad json".data(using: .utf8)!
        XCTAssertThrowsError(try Json(badJson)) {
            let actualError = NSError(domain: ($0 as NSError).domain, code: ($0 as NSError).code)
            XCTAssertEqual(actualError, Json.malformedJsonError)
        }
    }

    static var allTests = [
        ("testEmptyInitializerCreatesNullJson", testEmptyInitializerCreatesNullJson),
        ("testNull", testNull),
        ("testNumbers", testNumbers),
        ("testString", testString),
        ("testArray", testArray),
        ("testArraySubscript", testArraySubscript),
        ("testDictionaryDynamicMembers", testDictionaryDynamicMembers),
        ("testDictionaryAsDictionary", testDictionaryAsDictionary),
        ("testDictionarySubscript", testDictionarySubscript),
        ("testBadJsonThrowsExpectedError", testBadJsonThrowsExpectedError),
    ]
}
