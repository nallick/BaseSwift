//
//  AtomicPropertyTests.swift
//
//  Copyright © 2020 Purgatory Design. Licensed under the MIT License.
//

import BaseSwift
import XCTest

final class AtomicPropertyTests: XCTestCase {
    final class TestProperties {
        @Atomic var count = 0
        @Atomic var dictionary = [String: Int]()
    }

    let property = TestProperties()
    let queue = DispatchQueue(label: "AtomicPropertyTestQueue", attributes: .concurrent)
    let group = DispatchGroup()

    func testPerformAtomicAsCounter() {
        let threadCount = 4
        let loopCount = 1000
        let expectedCount = threadCount*loopCount

        for _ in 1 ... threadCount {
            group.enter()
            queue.async {
                for _ in 1 ... loopCount {
                    self.property.$count.performAtomic { $0 += 1 }
                }
                self.group.leave()
            }
        }
        group.wait()

        XCTAssertEqual(property.count, expectedCount)
    }

    func testPerformAtomicAsDictionary() {
        for index in 1 ... 3 {
            group.enter()
            queue.async {
                self.property.$dictionary.performAtomic { $0["key\(index)"] = index }
                self.group.leave()
            }
        }
        group.wait()

        XCTAssertEqual(property.dictionary, ["key1": 1, "key2": 2, "key3": 3])
        XCTAssertEqual(property.$dictionary.performAtomic { $0["key2"] }, 2)
    }

    static var allTests = [
        ("testPerformAtomicAsCounter", testPerformAtomicAsCounter),
        ("testPerformAtomicAsDictionary", testPerformAtomicAsDictionary),
    ]
}
