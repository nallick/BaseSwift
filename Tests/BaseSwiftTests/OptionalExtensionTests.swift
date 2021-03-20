//
//  OptionalExtensionTests.swift
//
//  Copyright © 2020 Purgatory Design. All rights reserved.
//

import BaseSwift
import XCTest

final class OptionalExtensionTests: XCTestCase {

    func testOptionalSomeNone() {
        let optionalSome: Int? = 0
        let optionalNone: Int? = nil

        XCTAssertTrue(optionalSome.isSome)
        XCTAssertFalse(optionalNone.isSome)
        
        XCTAssertFalse(optionalSome.isNone)
        XCTAssertTrue(optionalNone.isNone)
    }

    func testOptionalFilter() {
        let optionalZero: Int? = 0
        let optionalOne: Int? = 1
        let optionalNone: Int? = nil

        let filteredSomePass = optionalZero.filter { $0 == 0 }
        let filteredSomeFail = optionalOne.filter { $0 == 0 }
        let filteredNone = optionalNone.filter { $0 == 1 }

        XCTAssertEqual(filteredSomePass, 0)
        XCTAssertNil(filteredSomeFail)
        XCTAssertNil(filteredNone)
    }

    func testOptionalExpect() {
        let optionalSome: Int? = 0
        XCTAssertEqual(optionalSome.expect(), 0)
    }

    func testOptionalOrElseValue() {
        let expectedValue1 = 123
        let expectedValue2 = 456
        let optionalSome: Int? = expectedValue2
        let optionalNone: Int? = nil

        let actualValue1 = optionalNone.or(expectedValue1)
        let actualValue2 = optionalSome.or(789)

        XCTAssertEqual(actualValue1, expectedValue1)
        XCTAssertEqual(actualValue2, expectedValue2)
    }

    func testOptionalOrElseClosure() {
        let expectedValue1 = 123
        let expectedValue2 = 456
        let optionalSome: Int? = expectedValue2
        let optionalNone: Int? = nil

        let actualValue1 = optionalNone.or { expectedValue1 }
        let actualValue2 = optionalSome.or { 789 }

        XCTAssertEqual(actualValue1, expectedValue1)
        XCTAssertEqual(actualValue2, expectedValue2)
    }

    func testOptionalOrThrow() {
        let expectedError = NSError(domain: "Test", code: 1)
        let expectedValue = 123
        let optionalSome: Int? = expectedValue
        let optionalNone: Int? = nil

        XCTAssertThrowsError(try optionalNone.or(throw: expectedError)) { actualError in
            XCTAssertEqual(actualError as NSError, expectedError)
        }

        var actualValue: Int?
        XCTAssertNoThrow(actualValue = try optionalSome.or(throw: expectedError))
        XCTAssertEqual(actualValue, expectedValue)
    }

    func testOptionalOrElseError() {
        let expectedError = NSError(domain: "Test", code: 1)
        let unexpectedError = NSError(domain: "Test", code: 2)
        let willFail: Error? = expectedError
        let willSucceed: Error? = nil

        var actualValue1, actualValue2: Error?
        willFail.or { actualValue1 = $0 }
        willSucceed.or { actualValue2 = $0 }

        XCTAssertEqual((actualValue1 ?? unexpectedError) as NSError, expectedError)
        XCTAssertNil(actualValue2)
    }

    func testOptionalCollectionIsEmptyOrNil() {
        let optionalSomeNotEmpty: [Int]? = [0]
        let optionalSomeEmpty: [Int]? = []
        let optionalNone: [Int]? = nil

        XCTAssertFalse(optionalSomeNotEmpty.isEmptyOrNil)
        XCTAssertTrue(optionalSomeEmpty.isEmptyOrNil)
        XCTAssertTrue(optionalNone.isEmptyOrNil)

        XCTAssertTrue(optionalSomeNotEmpty.isNotEmptyOrNil)
        XCTAssertFalse(optionalSomeEmpty.isNotEmptyOrNil)
        XCTAssertFalse(optionalNone.isNotEmptyOrNil)
    }

    static var allTests = [
        ("testOptionalSomeNone", testOptionalSomeNone),
        ("testOptionalFilter", testOptionalFilter),
        ("testOptionalExpect", testOptionalExpect),
        ("testOptionalOrElseValue", testOptionalOrElseValue),
        ("testOptionalOrElseClosure", testOptionalOrElseClosure),
        ("testOptionalOrThrow", testOptionalOrThrow),
        ("testOptionalOrElseError", testOptionalOrElseError),
        ("testOptionalCollectionIsEmptyOrNil", testOptionalCollectionIsEmptyOrNil),
    ]
}
