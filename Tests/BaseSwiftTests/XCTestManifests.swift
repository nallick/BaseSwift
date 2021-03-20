import XCTest

#if !canImport(ObjectiveC)

public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AtomicPropertyTests.allTests),
        testCase(JsonTests.allTests),
        testCase(OptionalExtensionTests.allTests),
    ]
}

#endif
